//
//  FeedViewController.swift
//  Weather
//
//  Created by Matthew on 01.07.2020.
//  Copyright © 2020 Ostagram Inc. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let postList: [FakePost] = []
        /*[FakePost(
            user: FakeUser(name: "Bill Gates",
                           userPhoto: [FakePhoto(image: "Bill Gates/1", likes: 50)]),
            created_at: "8 minutes ago",
            contentType: .text,
            content: TextPostContent(text: "Shard: Scaling Giant Models with Conditional Computation and Automatic Sharding https://arxiv.org/abs/2006.16668"),
            likesCount: 23,
            commentsCount: 29,
            repostsCount: 4,
            viewsCount: 243),
        
        FakePost(
            user: FakeUser(name: "Elon Musk",
                           userPhoto: [FakePhoto(image: "Elon Musk/1", likes: 63)]),
            created_at: "3 hours ago",
            contentType: .photo,
            content: PhotoPostContent(image: "Elon Musk/1"),
            likesCount: 42,
            commentsCount: 29,
            repostsCount: 4,
            viewsCount: 243),
        FakePost(
            user: FakeUser(name: "Albert Einstein",
                           userPhoto: [FakePhoto(image: "Albert Einstein/1", likes: 63)]),
            created_at: "5 hours ago",
            contentType: .photo,
            content: PhotoPostContent(image: "Albert Einstein/1"),
            likesCount: 22,
            commentsCount: 29,
            repostsCount: 4,
            viewsCount: 243),
        FakePost(
            user: FakeUser(name: "Sergey Brin",
                           userPhoto: [FakePhoto(image: "Sergey Brin/1", likes: 63)]),
            created_at: "5 hours ago",
            contentType: .text,
            content: TextPostContent(text: """
        Группа исследователей из Технологического института Стивенса (США) изучила тонкие различия в речи пациентов, страдающих болезнью Альцгеймера и разработала инструмент на основе искусственного интеллекта, который, по их словам, может уловить изменения. Система разрабатывается как потенциальной способ ранней диагностики болезни.
                    Ученые сосредоточились на способах самовыражения некоторых людей, страдающих болезнью Альцгеймера. Эта и другие болезни, вызывающие слабоумие, могут повлиять на определенные части мозга, которые контролируют язык и речь. В результате изменений пациенты могут с трудом подобрать правильные слова или составлять целые предложения. Например, больной человек может использовать слово «книга» для описания газеты или заменять существительные местоимениями.

                    «На ранних стадиях болезни Альцгеймера (БА) языковой дефицит встречается у 8-10% людей. Дефект речи начинает проявляться чаще и становится более серьезным на поздних стадиях, — говорит ведущий автор исследования. — Статистика действительна только для ранних стадий БА. С учетом сказанного, анализ речи является стандартной практикой выявления болезни в клинических условиях».

                    Команда исследователей намеревалась разработать инструмент с ИИ, который мог бы обнаруживать эти речевые различия, используя стандартные задания с описанием изображений. В настоящее время подобная практика используется в медицине для диагностики болезни Альцгеймера.

                    Ученые собрали данные расшифровки стенограмм более 1000 интервью, где люди описывали рисунки. В тестах участвовали как пациенты с болезнью Альцгеймера, так и здоровые люди.

                    Эти тексты использовались для обучения алгоритма ИИ с разбивкой отдельных предложений и присвоением им числовых значений, чтобы система могла анализировать структурные и тематические отношения между частями и разными словами. Обучение позволило алгоритму научиться различать предложения, произносимые здоровыми людьми и людьми, страдающими болезнью Альцгеймера, с точностью более чем 95%.

                    Команда надеется расширить возможности инструмента для использования системы на других языках, кроме английского, и даже позволить разработке диагностировать болезнь Альцгеймера с помощью других типов текста. Например, по сообщениям в социальных сетях или электронной почте. Исследователи также видят большой потенциал в использовании системы для отслеживания того, как болезнь прогрессирует с течением времени. В дальнейшем система может стать новым способом обнаружения болезни на самых ранних стадиях.
        """),
        likesCount: 42,
        commentsCount: 29,
        repostsCount: 4,
        viewsCount: 243)
        
        
        /*
        Post(user: User(name: "Albert Einstein", userPhoto: [Photo(image: "Albert Einstein/1", likes: 63)]), created_at: "70 years ago", text: "", image: "", likesCount: 42, commentsCount: 29, repostsCount: 4, viewsCount: 243),
        Post(user: User(name: "Albert Einstein", userPhoto: [Photo(image: "Albert Einstein/1", likes: 63)]), created_at: "70 years ago", text: "Check it out my haircut!", image: "Albert Einstein/3", likesCount: 42, commentsCount: 29, repostsCount: 4, viewsCount: 243),
        Post(user: User(name: "Albert Einstein", userPhoto: [Photo(image: "Albert Einstein/1", likes: 63)]), created_at: "70 years ago", text: "", image: "Albert Einstein/2", likesCount: 42, commentsCount: 29, repostsCount: 4, viewsCount: 243),*/
    ]*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! PostViewCell
        let post = postList[indexPath.row]
        cell.set(post: post, screenWidth: tableView.frame.width)
        return cell
    }
   
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        tableView.dataSource = self
        tableView.delegate = self
        VkApi().getNewsfeed()
        
        
        
    }
    
    
    func showHelloMessage() {
        let alter = UIAlertController(title: "Wow!", message: "Hi, \(Session.currentUser.name)! How are you?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Great!", style: .cancel, handler: nil)
        alter.addAction(action)
        present(alter, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
