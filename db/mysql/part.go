package mysql

import (
	"database/sql"
	"errors"
	"fmt"
	"strings"

	"github.com/chaos-hip/partmate/models"
)

const (
	partTableName          = "Part"
	partCategoryTableName  = "PartCategory"
	partParameterTableName = "PartParameter"
)

var (
	// Search query for the parts search
	querySearchParts = fmt.Sprintf(`SELECT
		parts.id AS id,
		parts.category_id AS category_id,
		parts.name AS name,
		parts.description AS description,
		parts.comment AS comment,
		parts.stockLevel AS stockLevel,
		parts.minStockLevel AS minStockLevel,
		parts.status AS status,
		parts.storageLocation_id AS storageLocation_id,
		parts.needsReview AS needsReview,
		parts.partCondition AS partCondition,
		parts.lowStock AS lowStock,
		links.link AS link,
		attachments.id AS image_id,
		att_links.link AS image_link,
		(SELECT COUNT(*) FROM %s AS att WHERE att.part_id = parts.id) AS num_attachments
	FROM
		%s AS parts
	LEFT OUTER JOIN
		%s AS links
	ON
		links.link = (SELECT link FROM %s AS l2 WHERE l2.partID = parts.id ORDER BY l2.auto_generated LIMIT 1)
	LEFT OUTER JOIN
		%s AS attachments
	ON
		attachments.id = (SELECT id FROM %s AS a2 WHERE a2.part_id = parts.id AND a2.mimetype IN ('image/jpeg', 'image/png') ORDER BY a2.created ASC LIMIT 1)
	LEFT OUTER JOIN
		%s AS att_links
	ON
		att_links.link = (SELECT link FROM %s AS l3 WHERE l3.partAttachmentID = attachments.id ORDER BY l3.auto_generated LIMIT 1)
	`,
		partAttachmentTableName,
		partTableName,
		linkTableName,
		linkTableName,
		partAttachmentTableName,
		partAttachmentTableName,
		linkTableName,
		linkTableName,
	)

	querySearchPartsByTerm = fmt.Sprintf(`(
			parts.name LIKE ?
		OR
			parts.description LIKE ?
		OR
			parts.comment LIKE ?
		OR
			parts.id IN (SELECT part_id FROM %s WHERE valueType = 'string' AND stringValue LIKE ?)
		)`,
		partParameterTableName,
	)
	querySearchPartsByStorageLocation = fmt.Sprintf(
		`parts.storageLocation_id = (SELECT storageID FROM %s storageLinks WHERE storageLinks.link = ?)`,
		linkTableName,
	)
	querySearchPartsPostfix = `ORDER BY
		parts.name
	LIMIT ?
	OFFSET ?`

	queryGetPartByLink = fmt.Sprintf(`SELECT
		parts.id AS id,
		parts.category_id AS category_id,
		parts.name AS name,
		parts.description AS description,
		parts.comment AS comment,
		parts.stockLevel AS stockLevel,
		parts.minStockLevel AS minStockLevel,
		parts.status AS status,
		parts.storageLocation_id AS storageLocation_id,
		parts.needsReview AS needsReview,
		parts.partCondition AS partCondition,
		parts.lowStock AS lowStock,
		links.link AS link,
		attachments.id AS image_id,
		att_links.link AS image_link,
		(SELECT COUNT(*) FROM %s AS att WHERE att.part_id = parts.id) AS num_attachments
	FROM
		%s AS links
	LEFT OUTER JOIN
		%s AS parts
	ON
		links.partID = parts.id
	LEFT OUTER JOIN
		%s AS attachments
	ON
		attachments.id = (SELECT id FROM %s AS a2 WHERE a2.part_id = parts.id AND a2.mimetype IN ('image/jpeg', 'image/png') ORDER BY a2.created ASC LIMIT 1)
	LEFT OUTER JOIN
		%s AS att_links
	ON
		att_links.link = (SELECT link FROM %s AS l3 WHERE l3.partAttachmentID = attachments.id ORDER BY l3.auto_generated LIMIT 1)
	WHERE
		links.link = ?
	AND
		links.partID IS NOT NULL`,
		partAttachmentTableName,
		linkTableName,
		partTableName,
		partAttachmentTableName,
		partAttachmentTableName,
		linkTableName,
		linkTableName,
	)

	queryMovePart = fmt.Sprintf(`UPDATE %s SET storageLocation_id = ? WHERE id = ?`, partTableName)
)

func (d *DB) doCreateLinksForPart(p *models.Part) error {
	// Part link
	if !p.Link.Valid {
		l, err := d.CreateLink(models.Link{PartID: &p.ID, AutoGenerated: true})
		if err != nil {
			return fmt.Errorf("failed to create link for part %d: %w", p.ID, err)
		}
		p.Link.String = l.Link
		p.Link.Valid = true
	}
	if p.ImageID.Valid && !p.ImageLink.Valid {
		imgID := int(p.ImageID.Int64)
		l, err := d.CreateLink(models.Link{PartAttachmentID: &imgID, AutoGenerated: true})
		if err != nil {
			return fmt.Errorf("failed to create link for image %d: %w", imgID, err)
		}
		p.ImageLink.String = l.Link
		p.ImageLink.Valid = true
	}
	return nil
}

// GetPartByLink returns the part belonging to the link given
func (d *DB) GetPartByLink(id string) (*models.Part, error) {
	res := &models.Part{}
	if err := d.db.Get(res, queryGetPartByLink, id); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, fmt.Errorf("failed to fetch part: %w", err)
	}
	if err := d.doCreateLinksForPart(res); err != nil {
		return nil, err
	}
	sl, err := d.getStorageLocationsByIDs([]int{res.StorageLocationID})
	if err != nil {
		return nil, fmt.Errorf("failed to fetch storage location for part: %w", err)
	}
	if len(sl) > 0 {
		res.Storage = &sl[0]
	}
	return res, nil
}

// SearchParts searches for the parts matching the given search query and returns a list of them
// ordered by name
func (d *DB) SearchParts(search models.Search) ([]models.Part, error) {
	res := []*models.Part{}
	term := fmt.Sprintf("%%%s%%", search.Term)
	if search.Limit > maximumPageSize && !search.IgnoreMaxLimit {
		search.Limit = maximumPageSize
	}
	if search.Limit == 0 {
		search.Limit = defaultPageSize
	}
	where := []string{}
	params := []interface{}{}
	tmp := strings.TrimSpace(search.StorageLocationLink)
	if tmp != "" {
		where = append(where, querySearchPartsByStorageLocation)
		params = append(params, search.StorageLocationLink)
	}
	if search.Term != "" || len(where) == 0 {
		where = append(where, querySearchPartsByTerm)
		params = append(params, term, term, term, term)
	}
	query := fmt.Sprintf(`%s
	WHERE
		%s
	%s`,
		querySearchParts,
		strings.Join(where, " AND "),
		querySearchPartsPostfix,
	)
	params = append(params, search.Limit, search.Offset)
	if err := d.db.Select(&res, query, params...); err != nil {
		return nil, fmt.Errorf("failed to search parts: %w", err)
	}
	if len(res) == 0 {
		return []models.Part{}, nil
	}
	storageMap := map[int][]*models.Part{}
	// Create links for all the parts that have none - and images that have none
	for _, p := range res {
		if err := d.doCreateLinksForPart(p); err != nil {
			return nil, err
		}
		if _, ok := storageMap[p.StorageLocationID]; !ok {
			storageMap[p.StorageLocationID] = []*models.Part{}
		}
		storageMap[p.StorageLocationID] = append(storageMap[p.StorageLocationID], p)
	}
	// Add the storage locations
	var ids []int
	for k := range storageMap {
		ids = append(ids, k)
	}
	locations, err := d.getStorageLocationsByIDs(ids)
	if err != nil {
		return nil, fmt.Errorf("failed to retrieve storage location info: %w", err)
	}
	for _, loc := range locations {
		for _, part := range storageMap[loc.ID] {
			cpy := loc // Do a copy of the location to not map the counter var
			part.Storage = &cpy
		}
	}
	// Repack the parts
	out := []models.Part{}
	for _, p := range res {
		out = append(out, *p)
	}
	return out, nil
}

// AddPartStock adds one or more instances to the amount of parts present of the selected part type
func (d *DB) AddPartStock(id, price, comment string, amount uint) error {
	return fmt.Errorf("not implemented")
}

// RemovePartStock removes one or more parts of the selected part type from the inventory
func (d *DB) RemovePartStock(id, comment string, amount uint) error {
	return fmt.Errorf("not implemented")
}

// MovePart moves a part from its current storage location to a new one
// This function does not care about existence so the calling func needs to resolve the internal IDs and
// check if both included entities are really present
func (d *DB) MovePart(partID int, newLocationID int) error {
	if _, err := d.db.Exec(queryMovePart, newLocationID, partID); err != nil {
		return err
	}
	return nil
}
