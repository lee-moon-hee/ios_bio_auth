//
//  ViewController.m
//  BioAuth
//
//


#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)showAlert:(NSString*) title:(NSString*) message{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    });
}

// Touch ID  처리 함수
-(void)bioAuth{
    LAContext *context = [[LAContext alloc] init];
                              
        // Hide "Enter Password" button
        context.localizedFallbackTitle = @""; // 패스워드입력을 지움
        //context.maxBiometryFailures = @1; // 인증실패횟수를 조정가능하나 속성값을 아무리 올려도 5가 지나면 인증이 잠김
        NSError *error = nil;
        
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:@"Are you the device owner?"
                              reply:^(BOOL success, NSError *Error) {
                
                                  if (success) {// 인증을 성공
                                      [self showAlert:@"Success" :@"인증에 성공하였습니다." ];
                                      
                                  }else{// 인증 실패
                                      switch (Error.code) {
                                          case LAErrorAuthenticationFailed: // 사용자가 유효한 자격 증명을 제공하지 않아 인증에 실패
                                              [self showAlert:@"Error" :@"사용자 자격증명을 제공하지 않습니다."];
                                              break;
                                          case LAErrorUserCancel:// 사용자가 인증 대화 상자에서 취소 버튼을 눌렀을때
                                              [self showAlert:@"Error" :@"취소"];
                                              break;
                                          case LAErrorUserFallback://폴백 버튼을 탭했기 때문에 인증이 취소되었을때
                                              [self showAlert:@"Error" :@"인증취소"];
                                              break;
                                          case LAErrorTouchIDNotEnrolled://Touch ID에 등록 된 지문이 없을때
                                              [self showAlert:@"Error" :@"등록되어 있지 않은 인증정보입니다."];
                                              break;
                                          default:
                                              [self showAlert:@"Error" :@"인증 중 문제가 발생하였습니다."];
                                              break;
                                      }
                                  }
                              }];
        }else if(error){// 터치 ID를 사용할 수 없으므로 인증을 시작할 수 없는 경우
            [self showAlert:@"Error" :@"생체인증 기능이 꺼져 있습니다."];

            
        }else{ //기능자체를 사용할 수 없는 ios5이하일 경우에는 error자체가 생기지 않음
            [self showAlert:@"Error" :@"생체인증 기능이 존재하지 않습니다."];
        }
}

- (IBAction)bioAuth:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{

        [self bioAuth];
    });


}



@end
