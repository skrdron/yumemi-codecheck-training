//
//  RepositoryModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 櫻田龍之助 on 2024/05/02.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation
/*
 データ:アプリケーションが操作する情報
 レポの詳細情報なのでは
*/
struct Repository {
    var fullName: String
    var language: String
    var starsCount: Int
    var watchersCount: Int
    var forksCount: Int
    var openIssuesCount: Int
    var avatarURL: String
}
