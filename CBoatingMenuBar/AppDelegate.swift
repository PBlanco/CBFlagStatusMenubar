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
        let icon = NSImage(named: "statusIcon")
        icon!.template = true;
        
        statusItem.image = icon;
        statusItem.menu = statusMenu;
        
        let url = NSURL(string: "https://portal2.community-boating.org/pls/apex/CBI_PROD.FLAG_JS")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let splitString = dataString?.componentsSeparatedByString("\"")
            if (splitString?.count > 1) {
                let status = splitString![1];
                print(status);
                // TODO: change icon color here. Make into a class that is run every 5 minutes to update flag color 
                switch status {
                    case self.flagStatus.closed:
                        print("closed")
                    case self.flagStatus.green:
                        print("green")
                    case self.flagStatus.yellow:
                        print("yellow")
                    case self.flagStatus.red:
                        print("red")
                    default:
                        print("unknown status: " + status)
                }
            }
        }
        
        task.resume()

    }

    @IBAction func menuClicked(sender: NSMenuItem) {
        let url = NSURL(string: "http://www.community-boating.org");
        NSWorkspace.sharedWorkspace().openURL(url!)
    }
    
}

