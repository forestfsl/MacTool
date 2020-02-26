//
//  ViewController.m
//  TestMacTool
//
//  Created by songlin on 2020/1/2.
//  Copyright © 2020 toucu. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self InvokingPythonScriptAtPath:@"/Users/songlin/Desktop/TestMacTool/TestMacTool/nature_language_confuse.py"];
//    [self InvokingShellScriptAtPath:@"/Users/songlin/Desktop/TestMacTool/TestMacTool/testSed.sh"];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
-(id) InvokingPythonScriptAtPath :(NSString*) pyScriptPath
{
    NSTask *shellTask = [[NSTask alloc]init];
    [shellTask setLaunchPath:@"/bin/bash"];
    NSString *pyStr = [NSString stringWithFormat:@"/Library/Frameworks/Python.framework/Versions/3.7/bin/python3 %@",pyScriptPath];
    [shellTask setArguments:[NSArray arrayWithObjects:@"-c",pyStr, nil]];
    NSPipe *pipe = [[NSPipe alloc]init];
    [shellTask setStandardOutput:pipe];
    [shellTask launch];
    NSFileHandle *file = [pipe fileHandleForReading];
    NSData *data =[file readDataToEndOfFile];
    NSString *strReturnFromPython = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"The return content from python script is: %@",strReturnFromPython);
    return strReturnFromPython;
}


- (void)testShell{
   
//    NSArray *arguments = [NSArray arrayWithObjects: @"-c",@"echo hello world", nil];
      NSArray *arguments = [NSArray arrayWithObjects:@"-c", @"/Users/songlin/Desktop/TestMacTool/TestMacTool/testSed.sh", nil];
    [self runShellWithArguments:arguments completeBlock:nil];
}

-(void)runShellWithArguments:(NSArray *)arguments completeBlock:(dispatch_block_t)completeBlock{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSTask *task = [NSTask new];
        [task setLaunchPath:@"/bin/sh"];
        [task setArguments:arguments];
        [task launch];
        [task waitUntilExit];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock();
            }
        });
    });
}

-(id) InvokingShellScriptAtPath :(NSString*) shellScriptPath

{

    NSTask *shellTask = [[NSTask alloc]init];

    [shellTask setLaunchPath:@"/bin/sh"];

    NSString *shellStr = [NSString stringWithFormat:@"sh %@ 参数1",shellScriptPath];

   

 

//    -c 表示将后面的内容当成shellcode来执行

 

    [shellTask setArguments:[NSArray arrayWithObjects:@"-c",shellStr, nil]];

        

    NSPipe *pipe = [[NSPipe alloc]init];

    [shellTask setStandardOutput:pipe];

        

    [shellTask launch];

        

    NSFileHandle *file = [pipe fileHandleForReading];

    NSData *data =[file readDataToEndOfFile];

    NSString *strReturnFromShell = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];

    NSLog(@"The return content from shell script is: %@",strReturnFromShell);

        

    return strReturnFromShell;

 

 

}


@end
