//
//  AppDelegate.swift
//  CBoatingMenuBar
//
//  Created by Peter  Blanco on 5/31/16.
//  Copyright © 2016 Peter  Blanco. All rights reserved.
//

import Cocoa

enum FlagStatus : String {
	case closed = "C"
    case green = "G"
	case yellow = "Y"
	case red = "R"
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
	let statusItem = NSStatusBar.system.statusItem(withLength: -1)
	var flagStatus = FlagStatus.closed {
		didSet {
			let imageName: String

			switch self.flagStatus {
				case .closed: imageName = "closeFlag"
				case .green: imageName = "greenFlag"
				case .yellow: imageName = "yellowFlag"
				case .red: imageName = "redFlag"
			}

			self.statusItem.image = NSImage(named: imageName)
		}
	}

	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		self.statusItem.menu = self.statusMenu;

		updateFlag();
		Timer.scheduledTimer(timeInterval: 360, target: self, selector: #selector(AppDelegate.updateFlag), userInfo: nil, repeats: true);
    }
    
	@objc func updateFlag() -> Void {
		if let url = URL(string: "https://api.community-boating.org/api/flag") {
			let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
				if let data = data,
				   let dataString = String(data: data, encoding: .utf8)
				{
					let splitString = dataString.components(separatedBy: "\"")
					if splitString.count > 1 {
						let statusString = splitString[1]
						if let status = FlagStatus(rawValue: statusString) {
							DispatchQueue.main.async {
								self.flagStatus = status
							}
						}
					}
				}
			}

			task.resume()
		}
    }

    @IBAction func menuClicked(_ sender: NSMenuItem) {
        let url = URL(string: "http://www.community-boating.org");
		NSWorkspace.shared.open(url!)
    }
    
}

