public virtual with sharing class CustomException extends Exception{
    
    public class InputDataException extends CustomException {}
    public class CalloutException extends CustomException {}
}