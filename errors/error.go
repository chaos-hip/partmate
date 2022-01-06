package errors

import "github.com/gin-gonic/gin"

const (
	// TypeNotFound is the error type signalling that a searched entity was not available and thus not found
	TypeNotFound = "ENTITY_NOT_FOUND"
	// TypeIllegalData is the error type for malformed or otherwise wrong incoming data
	TypeIllegalData = "ILLEGAL_DATA"
	// TypeDBError is the error type for DB operations going wrong
	TypeDBError = "DB_OPERATION_FAILED"
	// TypeForbidden is the error type for failed logins
	TypeForbidden = "ACCESS_DENIED"
	// TypeConflict is the error type for trying to create an already existing entity
	TypeConflict = "CONFLICT"
	// TypeValidationFailed is the error type for invalid input data
	TypeValidationFailed = "VALIDATION_FAILED"
)

type ErrorResponse struct {
	Message string                 `json:"error"`
	Type    string                 `json:"type,omitempty"`
	Details map[string]interface{} `json:"details,omitempty"`
}

// NewResponse is a shortcut for creating an error response based on an error object
func NewResponse(errorType, message string, err error) *ErrorResponse {
	res := &ErrorResponse{
		Type:    errorType,
		Message: message,
	}
	if err != nil {
		res.Details = gin.H{
			"error": err.Error(),
		}
	}
	return res
}
