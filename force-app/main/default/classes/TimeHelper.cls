//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * @deprecated Use LeaveManager instead
 * @author Crosstalent
 * @group SIRH-Backend
 * @version 1.5
 */
global with sharing class TimeHelper {

  /**
   * Accepts leave requests and converts them to times object for the corresponding period
   * @param  arg List<Id> Ids of the leave request to accept
   * @return     A success message or the relevant error
   */
  webService static String acceptLeaveRequest(List<Id> arg) {
      return 'deprecated';
  }

  /**
   * Rejects leave requests
   * @param  arg List<Id> Ids of the leave request to convert
   * @return     A success message or the relevant error
   */
  webService static String rejectLeaveRequest(List<Id> arg) {
    return 'deprecated';
  }

  /**
   * Accepts leave requests and converts them to times object for the corresponding period
   * @deprecated Cannot be removed from package
   * @param  arg List<Id> Ids of the leave request to accept
   * @return     A success message or the relevant error
   */
  global static String acceptLeaveRequestStatic(String Id) {
    return 'deprecated';
  }

  /**
   * Rejects leave requests
   * @deprecated Cannot be removed from package
   * @param  arg List<Id> Ids of the leave request to convert
   * @return     A success message or the relevant error
   */
  global static String rejectLeaveRequestStatic(String Id) {
    return 'deprecated';
  }
}