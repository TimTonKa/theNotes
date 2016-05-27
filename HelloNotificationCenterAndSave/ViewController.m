//
//  ViewController.m
//  HelloNotificationCenterAndSave
//
//  Created by XueXin Tsai on 2016/5/12.
//  Copyright © 2016年 XueXin Tsai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *noteView;
@property (strong,nonatomic) NSMutableArray * notes;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray * notesFromUserDefault = [userDefaults objectForKey:@"notes"];
    
    if (notesFromUserDefault == nil) {
        self.notes = [NSMutableArray array];
    } else {
        self.notes = [NSMutableArray arrayWithArray:notesFromUserDefault];
    }
    
    if (self.index) {
        NSDictionary * theNote = notesFromUserDefault[self.index.integerValue];
        self.titleField.text = theNote[@"title"];
        self.noteView.text = theNote[@"content"];
    }

}
- (IBAction)save:(UIButton *)sender {
    if (self.index) {
        // 更新筆記內容
        // 拿 UserDefaults 中陣列的筆記，將其初始化成另一個可修改的
        // theNote 物件
        NSMutableDictionary * theNote = [NSMutableDictionary dictionaryWithDictionary:self.notes[self.index.integerValue]];
        // 將 theNote 物件的內容改為現在使用者所輸入的內容
        theNote[@"title"] = self.titleField.text;
        theNote[@"content"] = self.noteView.text;
        
        // 將 theNote 存入陣列當中，利用原本所在的位置
        [self.notes removeObjectAtIndex:self.index.integerValue];
        [self.notes insertObject:theNote atIndex:self.index.integerValue];
        
        // 將整個 Array 再次存回 NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setObject:self.notes forKey:@"notes"];
        // NSUserDefaults 同步
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 呼口號
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteHasBeenUpdated" object:nil];
    } else {
        // 新增筆記內容
        NSString * title = self.titleField.text;
        NSString * content = self.noteView.text;
        //將標題與內容存在 Dictionary
        NSDictionary * aNote = @{@"title":title,
                                 @"content":content};
        //將筆記存入陣列
        [self.notes addObject:aNote];
        
        //存入永久的儲存裡
        [[NSUserDefaults standardUserDefaults] setObject:self.notes forKey:@"notes"];
        //記得同步
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
