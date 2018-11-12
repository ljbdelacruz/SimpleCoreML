//
//  PlanetInfo.swift
//  SimpleAIVideoRecognition
//
//  Created by Lainel John Dela Cruz on 11/11/2018.
//  Copyright © 2018 Lainel John Dela Cruz. All rights reserved.
//

import Foundation

class PlanetInfo{
    var title,description, imgSrc:String;
    init(){
        self.title="";
        self.description="";
        self.imgSrc="";
    }
    convenience init(title:String, description:String, imgSrc:String){
        self.init();
        self.set(title: title, description: description, imgSrc:imgSrc);
    }
    func set(title:String, description:String, imgSrc:String){
        self.title=title;
        self.description=description;
        self.imgSrc=imgSrc;
    }
}
