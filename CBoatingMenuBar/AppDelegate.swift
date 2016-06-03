//
//  AppDelegate.swift
//  CBoatingMenuBar
//
//  Created by Peter  Blanco on 5/31/16.
//  Copyright © 2016 Peter  Blanco. All rights reserved.
//

import Cocoa

struct FlagStatus {
    let closed: String
    let green: String
    let yellow: String
    let red: String
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    let flagStatus = FlagStatus(closed: "C", green: "G", yellow: "Y", red: "R")
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        updateFlag();
        NSTimer.scheduledTimerWithTimeInterval(360, target: self, selector: #selector(AppDelegate.updateFlag), userInfo: nil, repeats: true);
    }
    
    func updateFlag() -> Void {
        let url = NSURL(string: "https://portal2.community-boating.org/pls/apex/CBI_PROD.FLAG_JS")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let splitString = dataString?.componentsSeparatedByString("\"")
            if (splitString?.count > 1) {
                var icon = NSImage(named: "yellowFlag")
                let status = splitString![1];
                
                switch status {
                case self.flagStatus.closed:
                    print("closed")
                    icon = NSImage(named: "closeFlag")
                case self.flagStatus.green:
                    print("green")
                    icon = NSImage(named: "greenFlag")
                case self.flagStatus.yellow:
                    print("yellow")
                    icon = NSImage(named: "yellowFlag")
                case self.flagStatus.red:
                    print("red")
                    icon = NSImage(named: "redFlag")
                default:
                    print("unknown status: " + status)
                }
                
                self.statusItem.image = icon;
                self.statusItem.menu = self.statusMenu;
            }
        }
        
        task.resume()
    }

    @IBAction func menuClicked(sender: NSMenuItem) {
        let url = NSURL(string: "http://www.community-boating.org");
        NSWorkspace.sharedWorkspace().openURL(url!)
    }
    
}

