package models

import (
	"fmt"
	"strings"
)

const (
	// TargetTypePart is the target type identifier for linking to parts
	TargetTypePart = "part"
)

//Link contains the URL for part-lookup (Table: mate_links)
type Link struct {
	Link          string `db:"link"`
	PartID        int    `db:"partID"`
	AutoGenerated bool   `db:"auto_generated"`
}

// ToDTO converts the link database model into its DTO representation
func (l *Link) ToDTO() LinkDTO {
	return LinkDTO{
		Link:          l.Link,
		TargetType:    TargetTypePart, // Static for now
		Target:        "",             // Our output does not provide the target (would be self-referencing)
		AutoGenerated: l.AutoGenerated,
	}
}

type LinkRetrievalFn func(string) (*Link, error)

type LinkDTO struct {
	// Link ID
	Link string `json:"link"`
	// Type of entity we are targeting (currently only "part")
	TargetType string `json:"targetType"`
	// ID of the target to link to - this has to be another link ID since we do not disclose the internal IDs of
	// entities.
	// When searching, links will be auto-generated for every single result (if no link exists)
	Target string `json:"target,omitempty"`
	// Was the link auto-generated?
	AutoGenerated bool `json:"autoGenerated"`
}

// ToLink converts the link data transfer object to its database model
func (l *LinkDTO) ToLink(fn LinkRetrievalFn) (*Link, error) {
	out := Link{
		Link:          strings.TrimSpace(l.Link),
		AutoGenerated: l.AutoGenerated,
	}
	switch l.TargetType {
	case TargetTypePart:
		// Get the link to determine the internal part ID
		link, err := fn(strings.TrimSpace(l.Target))
		if err != nil {
			return nil, fmt.Errorf("failed to fetch target: %w", err)
		}
		if link == nil || link.PartID <= 0 {
			return nil, fmt.Errorf("illegal target %#v", l.Target)
		}
		out.PartID = link.PartID
	default:
		return nil, fmt.Errorf("unknown target type %#v", l.TargetType)
	}
	return &out, nil
}

// Validate checks the DTO if all properties are set correctly
func (l *LinkDTO) Validate() error {
	if strings.TrimSpace(l.Link) == "" {
		return fmt.Errorf("link is empty")
	}
	switch l.TargetType {
	case TargetTypePart:
		if strings.TrimSpace(l.Target) == "" {
			return fmt.Errorf("target is empty")
		}
	default:
		return fmt.Errorf("unknown target type %#v", l.TargetType)
	}
	return nil
}
