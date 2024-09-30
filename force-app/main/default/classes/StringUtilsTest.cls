@IsTest
private class StringUtilsTest {
    
    @IsTest 
    private static void main() {
        String input = 'Hello!\nThis is a trial.\nThree lines';
        String[] result = StringUtils.split(input, '\n');
        System.assertEquals('Hello!', result[0]);
        System.assertEquals('This is a trial.', result[1]);
        System.assertEquals('Three lines', result[2]);
    }

    @IsTest
    private static void mainTwo() {
        String input = 'Hello!\r\nThis is a trial.\r\nThree lines';
        String[] result = StringUtils.split(input, '\r\n');
        System.assertEquals('Hello!', result[0]);
        System.assertEquals('This is a trial.', result[1]);
        System.assertEquals('Three lines', result[2]);
    }

    @IsTest
    private static void notSoDodgy() {
        String input = 'X';
        String[] result = StringUtils.split(input, '\n');
        System.assertEquals('X', result[0]);
    }

    @IsTest
    private static void dodgy() {
        String input = '';
        String[] result = StringUtils.split(input, '\n');
        System.assertEquals(0, result.size());
        input = null;
        result = StringUtils.split(input, '\n');
        System.assertEquals(0, result.size());
    }

    @IsTest
    private static void alsoDodgy() {
        String input = '\n';
        String [] result = StringUtils.split(input, '\n');
        System.assertEquals(2, result.size());
        System.assertEquals('', result[0]);
        System.assertEquals('', result[1]);
    }

    @IsTest
    private static void Argh() {
        String input = 'Oh No!\n';
        String [] result = StringUtils.split(input, '\n');
        System.assertEquals(2, result.size());
        System.assertEquals('Oh No!', result[0]);
        System.assertEquals('', result[1]);
    }

    @IsTest 
    private static void ArghTwo() {
        String input = 'Oh No!\r\n';
        String [] result = StringUtils.split(input, '\r\n');
        System.assertEquals(2, result.size());
        System.assertEquals('Oh No!', result[0]);
        System.assertEquals('', result[1]);
    }

    @IsTest 
    private static void ArghTwoDodgy() {
        String input = 'Oh No!\n';
        String [] result = StringUtils.split(input, '\r\n');
        System.assertEquals(1, result.size());
        System.assertEquals(input, result[0]);
    }
}