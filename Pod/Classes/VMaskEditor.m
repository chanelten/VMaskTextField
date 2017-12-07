//
//  VMaskEditor.m
//  Pods
//
//  Created by viniciusmo on 1/6/16.
//
//

#import "VMaskEditor.h"

@implementation VMaskEditor

+(BOOL)shouldChangeCharactersInRange:(NSRange)range
                   replacementString:(NSString *)string
                           textField:(UITextField *)textField
                                mask:(NSString *)mask{
    
    NSString * currentTextDigited = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length == 0) {
        unichar lastCharDeleted = 0;
        while (currentTextDigited.length > 0 && !isnumber([currentTextDigited characterAtIndex:currentTextDigited.length-1])) {
            lastCharDeleted = [currentTextDigited characterAtIndex:[currentTextDigited length] - 1];
            currentTextDigited = [currentTextDigited substringToIndex:[currentTextDigited length] - 1];
        }
        textField.text = currentTextDigited;
        [textField sendActionsForControlEvents:UIControlEventEditingChanged];
        return NO;
    }
    
    NSMutableString * returnText = [[NSMutableString alloc] init];
    if (currentTextDigited.length > mask.length) {
        return NO;
    }
    
    for (int i = 0, j = 0; i < mask.length && j < currentTextDigited.length;) {
        unichar  currentCharMask = [mask characterAtIndex:i];
        unichar  currentChar = [currentTextDigited characterAtIndex:j];
        if (isnumber(currentChar) && currentCharMask == '#') {
            [returnText appendString:[NSString stringWithFormat:@"%c",currentChar]];
            i++;
            j++;
        } else {
            // ignore unnecessary characters from currentTextDigited (eg: letters)
            if (!isnumber(currentChar) && currentCharMask != currentChar) {
                j++;
            // include mask's character
            } else if (isnumber(currentChar) && currentCharMask != currentChar) {
                [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
                i++;
            // include matching character from currentTextDigited & mask
            } else if (currentCharMask == currentChar) {
                [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
                j++;
                i++;
            }
        }
    }
    textField.text = returnText;
    [textField sendActionsForControlEvents:UIControlEventEditingChanged];
    return NO;
}

@end
