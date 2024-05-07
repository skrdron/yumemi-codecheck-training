//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by 櫻田龍之助 on 2024/05/01.
//  Copyright © 2024 YUMEMI Inc. All rights reserved.
//

import Foundation
//データの処理と変換
class RepositoryDetailViewModel {
    //リポジトリのデータを保持
    var repository: Repository?

    init(repository: Repository?) {
        //ビューモデルのrepositoryプロパティに設定
        self.repository = repository
    }
}
