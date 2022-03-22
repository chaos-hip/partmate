package mysql

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/chaos-hip/partmate/models"
	"github.com/jmoiron/sqlx"
)

const (
	storageLocationTableName         = "StorageLocation"
	storageLocationCategoryTableName = "StorageLocationCategory"
	storageLocationImageTableName    = "StorageLocationImage"
)

var (
	// The basic query needed for loading storage information
	queryBaseStorage = fmt.Sprintf(`SELECT
		storage.id AS id,
		storage.name AS name,
		links.link AS link,
		storage.category_id AS category_id,
		category.name AS category_name,
		IFNULL(category.description, '') AS category_description,
		category.categoryPath AS category_path,
		categoryLinks.link AS category_link,
		images.id AS image_id,
		imageLinks.link AS image_link,
		(SELECT COUNT(*) FROM %s AS parts WHERE parts.storageLocation_id = storage.id) AS parts_contained
	FROM
		%s AS storage
	LEFT OUTER JOIN
		%s AS links
	ON
		links.link = (SELECT link FROM %s AS l2 WHERE l2.storageID = storage.id ORDER BY l2.auto_generated LIMIT 1)
	LEFT OUTER JOIN
		%s as images
	ON
		images.storageLocation_id = storage.id
	LEFT OUTER JOIN
		%s AS imageLinks
	ON
		imageLinks.link = (SELECT link FROM %s AS l3 WHERE l3.storageImageID = images.id ORDER BY l3.auto_generated LIMIT 1)
	LEFT OUTER JOIN
		%s AS category
	ON
		category.id = storage.category_id
	LEFT OUTER JOIN
		%s AS categoryLinks
	ON
		categoryLinks.link = (SELECT link FROM %s AS l4 WHERE l4.storageCategoryID = category.id ORDER BY l4.auto_generated LIMIT 1)`,
		partTableName,
		storageLocationTableName,
		linkTableName,
		linkTableName,
		storageLocationImageTableName,
		linkTableName,
		linkTableName,
		storageLocationCategoryTableName,
		linkTableName,
		linkTableName)

	queryGetStorageByIDs = fmt.Sprintf(`%s WHERE storage.id IN (?);`, queryBaseStorage)

	queryGetStorageByLinkID = fmt.Sprintf(
		`SELECT
		storage.id AS id,
		storage.name AS name,
		links.link AS link,
		storage.category_id AS category_id,
		category.name AS category_name,
		IFNULL(category.description, '') AS category_description,
		category.categoryPath AS category_path,
		categoryLinks.link AS category_link,
		images.id AS image_id,
		imageLinks.link AS image_link,
		(SELECT COUNT(*) FROM %s AS parts WHERE parts.storageLocation_id = storage.id) AS parts_contained
	FROM
		%s AS links
	LEFT OUTER JOIN
		%s AS storage
	ON
		storage.id = links.storageID
	LEFT OUTER JOIN
		%s as images
	ON
		images.storageLocation_id = storage.id
	LEFT OUTER JOIN
		%s AS imageLinks
	ON
		imageLinks.link = (SELECT link FROM %s AS l3 WHERE l3.storageImageID = images.id ORDER BY l3.auto_generated LIMIT 1)
	LEFT OUTER JOIN
		%s AS category
	ON
		category.id = storage.category_id
	LEFT OUTER JOIN
		%s AS categoryLinks
	ON
		categoryLinks.link = (SELECT link FROM %s AS l4 WHERE l4.storageCategoryID = category.id ORDER BY l4.auto_generated LIMIT 1)
	WHERE
		links.link = ?
	AND
		links.storageID IS NOT NULL`,
		partTableName,
		linkTableName,
		storageLocationTableName,
		storageLocationImageTableName,
		linkTableName,
		linkTableName,
		storageLocationCategoryTableName,
		linkTableName,
		linkTableName,
	)

	querySearchStorage = fmt.Sprintf(`%s
	WHERE
		storage.name LIKE ?
	ORDER BY
		category.categoryPath,
		storage.name
	LIMIT ?
	OFFSET ?
		;`, queryBaseStorage)
)

// SearchStorageLocations searches for storage locations matching the provided search term.
// The result is provided as paginated list
func (d *DB) SearchStorageLocations(search models.Search) ([]models.StorageLocation, error) {
	res := []*models.StorageLocation{}
	term := fmt.Sprintf("%%%s%%", search.Term)
	if search.Limit > maximumPageSize {
		search.Limit = maximumPageSize
	}
	if search.Limit == 0 {
		search.Limit = defaultPageSize
	}
	if err := d.db.Select(&res, querySearchStorage, term, search.Limit, search.Offset); err != nil {
		return nil, fmt.Errorf("failed to search storage locations: %w", err)
	}
	if len(res) == 0 {
		return []models.StorageLocation{}, nil
	}
	// Create links and repack
	out := []models.StorageLocation{}
	// Create links for all the storage locations that have none
	for _, loc := range res {
		if err := d.doCreateLinksForStorage(loc); err != nil {
			return nil, err
		}
		out = append(out, *loc)
	}
	return out, nil
}

func (d *DB) doCreateLinksForStorage(loc *models.StorageLocation) error {
	var err error
	if !loc.Link.Valid {
		if loc.Link, err = d.doCreateLink(models.Link{StorageID: &loc.ID, AutoGenerated: true}); err != nil {
			return fmt.Errorf("failed to create link for storage location %#v: %w", loc.Name, err)
		}
	}
	if loc.ImageID.Valid && !loc.ImageLink.Valid {
		id := int(loc.ImageID.Int64)
		if loc.Link, err = d.doCreateLink(models.Link{StorageImageID: &id, AutoGenerated: true}); err != nil {
			return fmt.Errorf("failed to create link for storage location %#v: %w", loc.Name, err)
		}
	}
	if !loc.StorageCategory.Link.Valid {
		if loc.Link, err = d.doCreateLink(models.Link{StorageCategoryID: &loc.StorageCategory.ID, AutoGenerated: true}); err != nil {
			return fmt.Errorf("failed to create link for storage location %#v: %w", loc.Name, err)
		}
	}
	return nil
}

// getStorageLocationsByIDs returns the locations matching the IDs given
func (d *DB) getStorageLocationsByIDs(ids []int) ([]models.StorageLocation, error) {
	// Remap the IDs
	var inputArgs []interface{}
	for _, id := range ids {
		inputArgs = append(inputArgs, id)
	}
	res := []*models.StorageLocation{}
	query, args, err := sqlx.In(queryGetStorageByIDs, inputArgs)
	if err != nil {
		return nil, fmt.Errorf("failed to spread IN query")
	}
	query = d.db.Rebind(query)
	if err := d.db.Select(&res, query, args...); err != nil {
		return nil, fmt.Errorf("failed to load storage locations: %w", err)
	}
	out := []models.StorageLocation{}
	// Create links for all the storage locations that have none
	for _, loc := range res {
		if err := d.doCreateLinksForStorage(loc); err != nil {
			return nil, err
		}
		out = append(out, *loc)
	}
	return out, nil
}

// GetStorageLocationByLink returns the storage location that belongs to the given ID
func (d *DB) GetStorageLocationByLink(id string) (*models.StorageLocation, error) {
	res := &models.StorageLocation{}
	if err := d.db.Get(res, queryGetStorageByLinkID, id); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, fmt.Errorf("failed to fetch part: %w", err)
	}
	if err := d.doCreateLinksForStorage(res); err != nil {
		return nil, err
	}
	return res, nil
}
