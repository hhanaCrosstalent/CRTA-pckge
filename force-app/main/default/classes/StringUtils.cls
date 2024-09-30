//Security isCreateable() isUpdateable() isDeletable() checked
/**
 * Utility class for strings
 * @author Crosstalent
 * @group Utils
 * @version 1.0
 */
global class StringUtils {
      /**
       * Split the given string by the given seperator
       * @param Input string to split
       * @param Separator for the split, (not a regEx)
       * @return List<String>
       */
      global static List<String> split(String input, final String SEP) {
            List<String> result = new List<String>();
            if(input == null || input == '') {
                  return result;
            }
            if(!input.contains(SEP)) {
                  result.add(input);
                  return result;
            }
            
            for(Integer start = 0, finish = 0; finish != -1; start = input.indexOf(SEP, finish) + SEP.length()) {
                  finish = input.indexOf(SEP, start);
                  if(finish == -1) {
                      result.add(input.substring(start, input.length()));
                      break;
                  }
                  result.add(input.substring(start, finish));
            }
            return result;
      }
}