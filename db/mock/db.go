// Code generated by counterfeiter. DO NOT EDIT.
package mock

import (
	"sync"

	"git.chaos-hip.de/RepairCafe/PartMATE/db"
	"git.chaos-hip.de/RepairCafe/PartMATE/models"
)

type MockDB struct {
	AddPartStockStub        func(string, string, string, uint) error
	addPartStockMutex       sync.RWMutex
	addPartStockArgsForCall []struct {
		arg1 string
		arg2 string
		arg3 string
		arg4 uint
	}
	addPartStockReturns struct {
		result1 error
	}
	addPartStockReturnsOnCall map[int]struct {
		result1 error
	}
	CloseStub        func()
	closeMutex       sync.RWMutex
	closeArgsForCall []struct {
	}
	CreateLinkStub        func(string, string, string) (*models.Link, error)
	createLinkMutex       sync.RWMutex
	createLinkArgsForCall []struct {
		arg1 string
		arg2 string
		arg3 string
	}
	createLinkReturns struct {
		result1 *models.Link
		result2 error
	}
	createLinkReturnsOnCall map[int]struct {
		result1 *models.Link
		result2 error
	}
	CreatePartAttachmentEntryStub        func(string, string, string) (*models.Attachment, error)
	createPartAttachmentEntryMutex       sync.RWMutex
	createPartAttachmentEntryArgsForCall []struct {
		arg1 string
		arg2 string
		arg3 string
	}
	createPartAttachmentEntryReturns struct {
		result1 *models.Attachment
		result2 error
	}
	createPartAttachmentEntryReturnsOnCall map[int]struct {
		result1 *models.Attachment
		result2 error
	}
	DeleteLinkByIDStub        func(string) error
	deleteLinkByIDMutex       sync.RWMutex
	deleteLinkByIDArgsForCall []struct {
		arg1 string
	}
	deleteLinkByIDReturns struct {
		result1 error
	}
	deleteLinkByIDReturnsOnCall map[int]struct {
		result1 error
	}
	GetAttachmentEntryStub        func(string) (*models.Attachment, error)
	getAttachmentEntryMutex       sync.RWMutex
	getAttachmentEntryArgsForCall []struct {
		arg1 string
	}
	getAttachmentEntryReturns struct {
		result1 *models.Attachment
		result2 error
	}
	getAttachmentEntryReturnsOnCall map[int]struct {
		result1 *models.Attachment
		result2 error
	}
	GetPartByIDStub        func(string) (*models.Part, error)
	getPartByIDMutex       sync.RWMutex
	getPartByIDArgsForCall []struct {
		arg1 string
	}
	getPartByIDReturns struct {
		result1 *models.Part
		result2 error
	}
	getPartByIDReturnsOnCall map[int]struct {
		result1 *models.Part
		result2 error
	}
	GetUserByNameStub        func(string) (*models.User, error)
	getUserByNameMutex       sync.RWMutex
	getUserByNameArgsForCall []struct {
		arg1 string
	}
	getUserByNameReturns struct {
		result1 *models.User
		result2 error
	}
	getUserByNameReturnsOnCall map[int]struct {
		result1 *models.User
		result2 error
	}
	RemovePartStockStub        func(string, string, uint) error
	removePartStockMutex       sync.RWMutex
	removePartStockArgsForCall []struct {
		arg1 string
		arg2 string
		arg3 uint
	}
	removePartStockReturns struct {
		result1 error
	}
	removePartStockReturnsOnCall map[int]struct {
		result1 error
	}
	SearchPartsStub        func(models.Search) ([]models.Part, error)
	searchPartsMutex       sync.RWMutex
	searchPartsArgsForCall []struct {
		arg1 models.Search
	}
	searchPartsReturns struct {
		result1 []models.Part
		result2 error
	}
	searchPartsReturnsOnCall map[int]struct {
		result1 []models.Part
		result2 error
	}
	invocations      map[string][][]interface{}
	invocationsMutex sync.RWMutex
}

func (fake *MockDB) AddPartStock(arg1 string, arg2 string, arg3 string, arg4 uint) error {
	fake.addPartStockMutex.Lock()
	ret, specificReturn := fake.addPartStockReturnsOnCall[len(fake.addPartStockArgsForCall)]
	fake.addPartStockArgsForCall = append(fake.addPartStockArgsForCall, struct {
		arg1 string
		arg2 string
		arg3 string
		arg4 uint
	}{arg1, arg2, arg3, arg4})
	stub := fake.AddPartStockStub
	fakeReturns := fake.addPartStockReturns
	fake.recordInvocation("AddPartStock", []interface{}{arg1, arg2, arg3, arg4})
	fake.addPartStockMutex.Unlock()
	if stub != nil {
		return stub(arg1, arg2, arg3, arg4)
	}
	if specificReturn {
		return ret.result1
	}
	return fakeReturns.result1
}

func (fake *MockDB) AddPartStockCallCount() int {
	fake.addPartStockMutex.RLock()
	defer fake.addPartStockMutex.RUnlock()
	return len(fake.addPartStockArgsForCall)
}

func (fake *MockDB) AddPartStockCalls(stub func(string, string, string, uint) error) {
	fake.addPartStockMutex.Lock()
	defer fake.addPartStockMutex.Unlock()
	fake.AddPartStockStub = stub
}

func (fake *MockDB) AddPartStockArgsForCall(i int) (string, string, string, uint) {
	fake.addPartStockMutex.RLock()
	defer fake.addPartStockMutex.RUnlock()
	argsForCall := fake.addPartStockArgsForCall[i]
	return argsForCall.arg1, argsForCall.arg2, argsForCall.arg3, argsForCall.arg4
}

func (fake *MockDB) AddPartStockReturns(result1 error) {
	fake.addPartStockMutex.Lock()
	defer fake.addPartStockMutex.Unlock()
	fake.AddPartStockStub = nil
	fake.addPartStockReturns = struct {
		result1 error
	}{result1}
}

func (fake *MockDB) AddPartStockReturnsOnCall(i int, result1 error) {
	fake.addPartStockMutex.Lock()
	defer fake.addPartStockMutex.Unlock()
	fake.AddPartStockStub = nil
	if fake.addPartStockReturnsOnCall == nil {
		fake.addPartStockReturnsOnCall = make(map[int]struct {
			result1 error
		})
	}
	fake.addPartStockReturnsOnCall[i] = struct {
		result1 error
	}{result1}
}

func (fake *MockDB) Close() {
	fake.closeMutex.Lock()
	fake.closeArgsForCall = append(fake.closeArgsForCall, struct {
	}{})
	stub := fake.CloseStub
	fake.recordInvocation("Close", []interface{}{})
	fake.closeMutex.Unlock()
	if stub != nil {
		fake.CloseStub()
	}
}

func (fake *MockDB) CloseCallCount() int {
	fake.closeMutex.RLock()
	defer fake.closeMutex.RUnlock()
	return len(fake.closeArgsForCall)
}

func (fake *MockDB) CloseCalls(stub func()) {
	fake.closeMutex.Lock()
	defer fake.closeMutex.Unlock()
	fake.CloseStub = stub
}

func (fake *MockDB) CreateLink(arg1 string, arg2 string, arg3 string) (*models.Link, error) {
	fake.createLinkMutex.Lock()
	ret, specificReturn := fake.createLinkReturnsOnCall[len(fake.createLinkArgsForCall)]
	fake.createLinkArgsForCall = append(fake.createLinkArgsForCall, struct {
		arg1 string
		arg2 string
		arg3 string
	}{arg1, arg2, arg3})
	stub := fake.CreateLinkStub
	fakeReturns := fake.createLinkReturns
	fake.recordInvocation("CreateLink", []interface{}{arg1, arg2, arg3})
	fake.createLinkMutex.Unlock()
	if stub != nil {
		return stub(arg1, arg2, arg3)
	}
	if specificReturn {
		return ret.result1, ret.result2
	}
	return fakeReturns.result1, fakeReturns.result2
}

func (fake *MockDB) CreateLinkCallCount() int {
	fake.createLinkMutex.RLock()
	defer fake.createLinkMutex.RUnlock()
	return len(fake.createLinkArgsForCall)
}

func (fake *MockDB) CreateLinkCalls(stub func(string, string, string) (*models.Link, error)) {
	fake.createLinkMutex.Lock()
	defer fake.createLinkMutex.Unlock()
	fake.CreateLinkStub = stub
}

func (fake *MockDB) CreateLinkArgsForCall(i int) (string, string, string) {
	fake.createLinkMutex.RLock()
	defer fake.createLinkMutex.RUnlock()
	argsForCall := fake.createLinkArgsForCall[i]
	return argsForCall.arg1, argsForCall.arg2, argsForCall.arg3
}

func (fake *MockDB) CreateLinkReturns(result1 *models.Link, result2 error) {
	fake.createLinkMutex.Lock()
	defer fake.createLinkMutex.Unlock()
	fake.CreateLinkStub = nil
	fake.createLinkReturns = struct {
		result1 *models.Link
		result2 error
	}{result1, result2}
}

func (fake *MockDB) CreateLinkReturnsOnCall(i int, result1 *models.Link, result2 error) {
	fake.createLinkMutex.Lock()
	defer fake.createLinkMutex.Unlock()
	fake.CreateLinkStub = nil
	if fake.createLinkReturnsOnCall == nil {
		fake.createLinkReturnsOnCall = make(map[int]struct {
			result1 *models.Link
			result2 error
		})
	}
	fake.createLinkReturnsOnCall[i] = struct {
		result1 *models.Link
		result2 error
	}{result1, result2}
}

func (fake *MockDB) CreatePartAttachmentEntry(arg1 string, arg2 string, arg3 string) (*models.Attachment, error) {
	fake.createPartAttachmentEntryMutex.Lock()
	ret, specificReturn := fake.createPartAttachmentEntryReturnsOnCall[len(fake.createPartAttachmentEntryArgsForCall)]
	fake.createPartAttachmentEntryArgsForCall = append(fake.createPartAttachmentEntryArgsForCall, struct {
		arg1 string
		arg2 string
		arg3 string
	}{arg1, arg2, arg3})
	stub := fake.CreatePartAttachmentEntryStub
	fakeReturns := fake.createPartAttachmentEntryReturns
	fake.recordInvocation("CreatePartAttachmentEntry", []interface{}{arg1, arg2, arg3})
	fake.createPartAttachmentEntryMutex.Unlock()
	if stub != nil {
		return stub(arg1, arg2, arg3)
	}
	if specificReturn {
		return ret.result1, ret.result2
	}
	return fakeReturns.result1, fakeReturns.result2
}

func (fake *MockDB) CreatePartAttachmentEntryCallCount() int {
	fake.createPartAttachmentEntryMutex.RLock()
	defer fake.createPartAttachmentEntryMutex.RUnlock()
	return len(fake.createPartAttachmentEntryArgsForCall)
}

func (fake *MockDB) CreatePartAttachmentEntryCalls(stub func(string, string, string) (*models.Attachment, error)) {
	fake.createPartAttachmentEntryMutex.Lock()
	defer fake.createPartAttachmentEntryMutex.Unlock()
	fake.CreatePartAttachmentEntryStub = stub
}

func (fake *MockDB) CreatePartAttachmentEntryArgsForCall(i int) (string, string, string) {
	fake.createPartAttachmentEntryMutex.RLock()
	defer fake.createPartAttachmentEntryMutex.RUnlock()
	argsForCall := fake.createPartAttachmentEntryArgsForCall[i]
	return argsForCall.arg1, argsForCall.arg2, argsForCall.arg3
}

func (fake *MockDB) CreatePartAttachmentEntryReturns(result1 *models.Attachment, result2 error) {
	fake.createPartAttachmentEntryMutex.Lock()
	defer fake.createPartAttachmentEntryMutex.Unlock()
	fake.CreatePartAttachmentEntryStub = nil
	fake.createPartAttachmentEntryReturns = struct {
		result1 *models.Attachment
		result2 error
	}{result1, result2}
}

func (fake *MockDB) CreatePartAttachmentEntryReturnsOnCall(i int, result1 *models.Attachment, result2 error) {
	fake.createPartAttachmentEntryMutex.Lock()
	defer fake.createPartAttachmentEntryMutex.Unlock()
	fake.CreatePartAttachmentEntryStub = nil
	if fake.createPartAttachmentEntryReturnsOnCall == nil {
		fake.createPartAttachmentEntryReturnsOnCall = make(map[int]struct {
			result1 *models.Attachment
			result2 error
		})
	}
	fake.createPartAttachmentEntryReturnsOnCall[i] = struct {
		result1 *models.Attachment
		result2 error
	}{result1, result2}
}

func (fake *MockDB) DeleteLinkByID(arg1 string) error {
	fake.deleteLinkByIDMutex.Lock()
	ret, specificReturn := fake.deleteLinkByIDReturnsOnCall[len(fake.deleteLinkByIDArgsForCall)]
	fake.deleteLinkByIDArgsForCall = append(fake.deleteLinkByIDArgsForCall, struct {
		arg1 string
	}{arg1})
	stub := fake.DeleteLinkByIDStub
	fakeReturns := fake.deleteLinkByIDReturns
	fake.recordInvocation("DeleteLinkByID", []interface{}{arg1})
	fake.deleteLinkByIDMutex.Unlock()
	if stub != nil {
		return stub(arg1)
	}
	if specificReturn {
		return ret.result1
	}
	return fakeReturns.result1
}

func (fake *MockDB) DeleteLinkByIDCallCount() int {
	fake.deleteLinkByIDMutex.RLock()
	defer fake.deleteLinkByIDMutex.RUnlock()
	return len(fake.deleteLinkByIDArgsForCall)
}

func (fake *MockDB) DeleteLinkByIDCalls(stub func(string) error) {
	fake.deleteLinkByIDMutex.Lock()
	defer fake.deleteLinkByIDMutex.Unlock()
	fake.DeleteLinkByIDStub = stub
}

func (fake *MockDB) DeleteLinkByIDArgsForCall(i int) string {
	fake.deleteLinkByIDMutex.RLock()
	defer fake.deleteLinkByIDMutex.RUnlock()
	argsForCall := fake.deleteLinkByIDArgsForCall[i]
	return argsForCall.arg1
}

func (fake *MockDB) DeleteLinkByIDReturns(result1 error) {
	fake.deleteLinkByIDMutex.Lock()
	defer fake.deleteLinkByIDMutex.Unlock()
	fake.DeleteLinkByIDStub = nil
	fake.deleteLinkByIDReturns = struct {
		result1 error
	}{result1}
}

func (fake *MockDB) DeleteLinkByIDReturnsOnCall(i int, result1 error) {
	fake.deleteLinkByIDMutex.Lock()
	defer fake.deleteLinkByIDMutex.Unlock()
	fake.DeleteLinkByIDStub = nil
	if fake.deleteLinkByIDReturnsOnCall == nil {
		fake.deleteLinkByIDReturnsOnCall = make(map[int]struct {
			result1 error
		})
	}
	fake.deleteLinkByIDReturnsOnCall[i] = struct {
		result1 error
	}{result1}
}

func (fake *MockDB) GetAttachmentEntry(arg1 string) (*models.Attachment, error) {
	fake.getAttachmentEntryMutex.Lock()
	ret, specificReturn := fake.getAttachmentEntryReturnsOnCall[len(fake.getAttachmentEntryArgsForCall)]
	fake.getAttachmentEntryArgsForCall = append(fake.getAttachmentEntryArgsForCall, struct {
		arg1 string
	}{arg1})
	stub := fake.GetAttachmentEntryStub
	fakeReturns := fake.getAttachmentEntryReturns
	fake.recordInvocation("GetAttachmentEntry", []interface{}{arg1})
	fake.getAttachmentEntryMutex.Unlock()
	if stub != nil {
		return stub(arg1)
	}
	if specificReturn {
		return ret.result1, ret.result2
	}
	return fakeReturns.result1, fakeReturns.result2
}

func (fake *MockDB) GetAttachmentEntryCallCount() int {
	fake.getAttachmentEntryMutex.RLock()
	defer fake.getAttachmentEntryMutex.RUnlock()
	return len(fake.getAttachmentEntryArgsForCall)
}

func (fake *MockDB) GetAttachmentEntryCalls(stub func(string) (*models.Attachment, error)) {
	fake.getAttachmentEntryMutex.Lock()
	defer fake.getAttachmentEntryMutex.Unlock()
	fake.GetAttachmentEntryStub = stub
}

func (fake *MockDB) GetAttachmentEntryArgsForCall(i int) string {
	fake.getAttachmentEntryMutex.RLock()
	defer fake.getAttachmentEntryMutex.RUnlock()
	argsForCall := fake.getAttachmentEntryArgsForCall[i]
	return argsForCall.arg1
}

func (fake *MockDB) GetAttachmentEntryReturns(result1 *models.Attachment, result2 error) {
	fake.getAttachmentEntryMutex.Lock()
	defer fake.getAttachmentEntryMutex.Unlock()
	fake.GetAttachmentEntryStub = nil
	fake.getAttachmentEntryReturns = struct {
		result1 *models.Attachment
		result2 error
	}{result1, result2}
}

func (fake *MockDB) GetAttachmentEntryReturnsOnCall(i int, result1 *models.Attachment, result2 error) {
	fake.getAttachmentEntryMutex.Lock()
	defer fake.getAttachmentEntryMutex.Unlock()
	fake.GetAttachmentEntryStub = nil
	if fake.getAttachmentEntryReturnsOnCall == nil {
		fake.getAttachmentEntryReturnsOnCall = make(map[int]struct {
			result1 *models.Attachment
			result2 error
		})
	}
	fake.getAttachmentEntryReturnsOnCall[i] = struct {
		result1 *models.Attachment
		result2 error
	}{result1, result2}
}

func (fake *MockDB) GetPartByID(arg1 string) (*models.Part, error) {
	fake.getPartByIDMutex.Lock()
	ret, specificReturn := fake.getPartByIDReturnsOnCall[len(fake.getPartByIDArgsForCall)]
	fake.getPartByIDArgsForCall = append(fake.getPartByIDArgsForCall, struct {
		arg1 string
	}{arg1})
	stub := fake.GetPartByIDStub
	fakeReturns := fake.getPartByIDReturns
	fake.recordInvocation("GetPartByID", []interface{}{arg1})
	fake.getPartByIDMutex.Unlock()
	if stub != nil {
		return stub(arg1)
	}
	if specificReturn {
		return ret.result1, ret.result2
	}
	return fakeReturns.result1, fakeReturns.result2
}

func (fake *MockDB) GetPartByIDCallCount() int {
	fake.getPartByIDMutex.RLock()
	defer fake.getPartByIDMutex.RUnlock()
	return len(fake.getPartByIDArgsForCall)
}

func (fake *MockDB) GetPartByIDCalls(stub func(string) (*models.Part, error)) {
	fake.getPartByIDMutex.Lock()
	defer fake.getPartByIDMutex.Unlock()
	fake.GetPartByIDStub = stub
}

func (fake *MockDB) GetPartByIDArgsForCall(i int) string {
	fake.getPartByIDMutex.RLock()
	defer fake.getPartByIDMutex.RUnlock()
	argsForCall := fake.getPartByIDArgsForCall[i]
	return argsForCall.arg1
}

func (fake *MockDB) GetPartByIDReturns(result1 *models.Part, result2 error) {
	fake.getPartByIDMutex.Lock()
	defer fake.getPartByIDMutex.Unlock()
	fake.GetPartByIDStub = nil
	fake.getPartByIDReturns = struct {
		result1 *models.Part
		result2 error
	}{result1, result2}
}

func (fake *MockDB) GetPartByIDReturnsOnCall(i int, result1 *models.Part, result2 error) {
	fake.getPartByIDMutex.Lock()
	defer fake.getPartByIDMutex.Unlock()
	fake.GetPartByIDStub = nil
	if fake.getPartByIDReturnsOnCall == nil {
		fake.getPartByIDReturnsOnCall = make(map[int]struct {
			result1 *models.Part
			result2 error
		})
	}
	fake.getPartByIDReturnsOnCall[i] = struct {
		result1 *models.Part
		result2 error
	}{result1, result2}
}

func (fake *MockDB) GetUserByName(arg1 string) (*models.User, error) {
	fake.getUserByNameMutex.Lock()
	ret, specificReturn := fake.getUserByNameReturnsOnCall[len(fake.getUserByNameArgsForCall)]
	fake.getUserByNameArgsForCall = append(fake.getUserByNameArgsForCall, struct {
		arg1 string
	}{arg1})
	stub := fake.GetUserByNameStub
	fakeReturns := fake.getUserByNameReturns
	fake.recordInvocation("GetUserByName", []interface{}{arg1})
	fake.getUserByNameMutex.Unlock()
	if stub != nil {
		return stub(arg1)
	}
	if specificReturn {
		return ret.result1, ret.result2
	}
	return fakeReturns.result1, fakeReturns.result2
}

func (fake *MockDB) GetUserByNameCallCount() int {
	fake.getUserByNameMutex.RLock()
	defer fake.getUserByNameMutex.RUnlock()
	return len(fake.getUserByNameArgsForCall)
}

func (fake *MockDB) GetUserByNameCalls(stub func(string) (*models.User, error)) {
	fake.getUserByNameMutex.Lock()
	defer fake.getUserByNameMutex.Unlock()
	fake.GetUserByNameStub = stub
}

func (fake *MockDB) GetUserByNameArgsForCall(i int) string {
	fake.getUserByNameMutex.RLock()
	defer fake.getUserByNameMutex.RUnlock()
	argsForCall := fake.getUserByNameArgsForCall[i]
	return argsForCall.arg1
}

func (fake *MockDB) GetUserByNameReturns(result1 *models.User, result2 error) {
	fake.getUserByNameMutex.Lock()
	defer fake.getUserByNameMutex.Unlock()
	fake.GetUserByNameStub = nil
	fake.getUserByNameReturns = struct {
		result1 *models.User
		result2 error
	}{result1, result2}
}

func (fake *MockDB) GetUserByNameReturnsOnCall(i int, result1 *models.User, result2 error) {
	fake.getUserByNameMutex.Lock()
	defer fake.getUserByNameMutex.Unlock()
	fake.GetUserByNameStub = nil
	if fake.getUserByNameReturnsOnCall == nil {
		fake.getUserByNameReturnsOnCall = make(map[int]struct {
			result1 *models.User
			result2 error
		})
	}
	fake.getUserByNameReturnsOnCall[i] = struct {
		result1 *models.User
		result2 error
	}{result1, result2}
}

func (fake *MockDB) RemovePartStock(arg1 string, arg2 string, arg3 uint) error {
	fake.removePartStockMutex.Lock()
	ret, specificReturn := fake.removePartStockReturnsOnCall[len(fake.removePartStockArgsForCall)]
	fake.removePartStockArgsForCall = append(fake.removePartStockArgsForCall, struct {
		arg1 string
		arg2 string
		arg3 uint
	}{arg1, arg2, arg3})
	stub := fake.RemovePartStockStub
	fakeReturns := fake.removePartStockReturns
	fake.recordInvocation("RemovePartStock", []interface{}{arg1, arg2, arg3})
	fake.removePartStockMutex.Unlock()
	if stub != nil {
		return stub(arg1, arg2, arg3)
	}
	if specificReturn {
		return ret.result1
	}
	return fakeReturns.result1
}

func (fake *MockDB) RemovePartStockCallCount() int {
	fake.removePartStockMutex.RLock()
	defer fake.removePartStockMutex.RUnlock()
	return len(fake.removePartStockArgsForCall)
}

func (fake *MockDB) RemovePartStockCalls(stub func(string, string, uint) error) {
	fake.removePartStockMutex.Lock()
	defer fake.removePartStockMutex.Unlock()
	fake.RemovePartStockStub = stub
}

func (fake *MockDB) RemovePartStockArgsForCall(i int) (string, string, uint) {
	fake.removePartStockMutex.RLock()
	defer fake.removePartStockMutex.RUnlock()
	argsForCall := fake.removePartStockArgsForCall[i]
	return argsForCall.arg1, argsForCall.arg2, argsForCall.arg3
}

func (fake *MockDB) RemovePartStockReturns(result1 error) {
	fake.removePartStockMutex.Lock()
	defer fake.removePartStockMutex.Unlock()
	fake.RemovePartStockStub = nil
	fake.removePartStockReturns = struct {
		result1 error
	}{result1}
}

func (fake *MockDB) RemovePartStockReturnsOnCall(i int, result1 error) {
	fake.removePartStockMutex.Lock()
	defer fake.removePartStockMutex.Unlock()
	fake.RemovePartStockStub = nil
	if fake.removePartStockReturnsOnCall == nil {
		fake.removePartStockReturnsOnCall = make(map[int]struct {
			result1 error
		})
	}
	fake.removePartStockReturnsOnCall[i] = struct {
		result1 error
	}{result1}
}

func (fake *MockDB) SearchParts(arg1 models.Search) ([]models.Part, error) {
	fake.searchPartsMutex.Lock()
	ret, specificReturn := fake.searchPartsReturnsOnCall[len(fake.searchPartsArgsForCall)]
	fake.searchPartsArgsForCall = append(fake.searchPartsArgsForCall, struct {
		arg1 models.Search
	}{arg1})
	stub := fake.SearchPartsStub
	fakeReturns := fake.searchPartsReturns
	fake.recordInvocation("SearchParts", []interface{}{arg1})
	fake.searchPartsMutex.Unlock()
	if stub != nil {
		return stub(arg1)
	}
	if specificReturn {
		return ret.result1, ret.result2
	}
	return fakeReturns.result1, fakeReturns.result2
}

func (fake *MockDB) SearchPartsCallCount() int {
	fake.searchPartsMutex.RLock()
	defer fake.searchPartsMutex.RUnlock()
	return len(fake.searchPartsArgsForCall)
}

func (fake *MockDB) SearchPartsCalls(stub func(models.Search) ([]models.Part, error)) {
	fake.searchPartsMutex.Lock()
	defer fake.searchPartsMutex.Unlock()
	fake.SearchPartsStub = stub
}

func (fake *MockDB) SearchPartsArgsForCall(i int) models.Search {
	fake.searchPartsMutex.RLock()
	defer fake.searchPartsMutex.RUnlock()
	argsForCall := fake.searchPartsArgsForCall[i]
	return argsForCall.arg1
}

func (fake *MockDB) SearchPartsReturns(result1 []models.Part, result2 error) {
	fake.searchPartsMutex.Lock()
	defer fake.searchPartsMutex.Unlock()
	fake.SearchPartsStub = nil
	fake.searchPartsReturns = struct {
		result1 []models.Part
		result2 error
	}{result1, result2}
}

func (fake *MockDB) SearchPartsReturnsOnCall(i int, result1 []models.Part, result2 error) {
	fake.searchPartsMutex.Lock()
	defer fake.searchPartsMutex.Unlock()
	fake.SearchPartsStub = nil
	if fake.searchPartsReturnsOnCall == nil {
		fake.searchPartsReturnsOnCall = make(map[int]struct {
			result1 []models.Part
			result2 error
		})
	}
	fake.searchPartsReturnsOnCall[i] = struct {
		result1 []models.Part
		result2 error
	}{result1, result2}
}

func (fake *MockDB) Invocations() map[string][][]interface{} {
	fake.invocationsMutex.RLock()
	defer fake.invocationsMutex.RUnlock()
	fake.addPartStockMutex.RLock()
	defer fake.addPartStockMutex.RUnlock()
	fake.closeMutex.RLock()
	defer fake.closeMutex.RUnlock()
	fake.createLinkMutex.RLock()
	defer fake.createLinkMutex.RUnlock()
	fake.createPartAttachmentEntryMutex.RLock()
	defer fake.createPartAttachmentEntryMutex.RUnlock()
	fake.deleteLinkByIDMutex.RLock()
	defer fake.deleteLinkByIDMutex.RUnlock()
	fake.getAttachmentEntryMutex.RLock()
	defer fake.getAttachmentEntryMutex.RUnlock()
	fake.getPartByIDMutex.RLock()
	defer fake.getPartByIDMutex.RUnlock()
	fake.getUserByNameMutex.RLock()
	defer fake.getUserByNameMutex.RUnlock()
	fake.removePartStockMutex.RLock()
	defer fake.removePartStockMutex.RUnlock()
	fake.searchPartsMutex.RLock()
	defer fake.searchPartsMutex.RUnlock()
	copiedInvocations := map[string][][]interface{}{}
	for key, value := range fake.invocations {
		copiedInvocations[key] = value
	}
	return copiedInvocations
}

func (fake *MockDB) recordInvocation(key string, args []interface{}) {
	fake.invocationsMutex.Lock()
	defer fake.invocationsMutex.Unlock()
	if fake.invocations == nil {
		fake.invocations = map[string][][]interface{}{}
	}
	if fake.invocations[key] == nil {
		fake.invocations[key] = [][]interface{}{}
	}
	fake.invocations[key] = append(fake.invocations[key], args)
}

var _ db.DB = new(MockDB)
