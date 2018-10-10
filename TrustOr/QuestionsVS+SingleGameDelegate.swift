import UIKit

extension QuestionsVC: SingleGameDelegate {
    func textScore(_ score: Int) -> String {
        switch score {
        case 1...Int.max: return "+"+String(score)
        case 0: return ""+String(score)
        default: return String(score)
        }
    }
    func setScoreTitle(title: String, score: Int) {
        let navView = UINib(nibName: "navView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        let width = navigationController!.navigationBar.frame.width
        let height = navigationController!.navigationBar.frame.height
        navView.frame = CGRect(x: 0,y: 0, width: width-2*K.Margins.title, height: height)
        if let titleLabel = navView.viewWithTag(1000) as? UILabel {
            titleLabel.text = title
        }
        if let scoreLabel = navView.viewWithTag(1001) as? UILabel {
            scoreLabel.text = textScore(score)
        }
        navigationItem.titleView = navView
    }
    
    func showAnswer(question: String, comment: String) {
        commentText.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.commentText.flashScrollIndicators()
        })
        if questionsPack.questionTasks[gameState.singleGameState.currentNumber].answer == true {
            resultLabel.backgroundColor = K.Colors.ResultBar.trueAnswer
            switch gameState.singleGameState.answerResultString {
            case K.Labels.ResultBar.Result.win:
                resultLabel.text = K.Labels.ResultBar.True.win
                K.Sounds.correct?.play()
            case K.Labels.ResultBar.Result.loose:
                resultLabel.text = K.Labels.ResultBar.True.loose
                K.Sounds.error?.play()
            default:
                resultLabel.text = K.Labels.ResultBar.True.neutral
            }
        } else {
            resultLabel.backgroundColor = K.Colors.ResultBar.falseAnswer
            switch gameState.singleGameState.answerResultString {
            case K.Labels.ResultBar.Result.win:
                resultLabel.text = K.Labels.ResultBar.False.win
                K.Sounds.correct?.play()
            case K.Labels.ResultBar.Result.loose:
                resultLabel.text = K.Labels.ResultBar.False.loose
                K.Sounds.error?.play()
            default:
                resultLabel.text = K.Labels.ResultBar.False.neutral
            }
        }
        resultLabel.text = resultLabel.text! + gameState.singleGameState.answerResultString
        resultLabel.isHidden = false
        reloadTexts(question: question, comment: comment)
    }
    func hideAnswer() {
        commentText.isHidden = true
        resultLabel.isHidden = true
    }
    func showUIAnswerMode(question: String, comment: String) {
        hideAnswer()
        bottomButton.isHidden = true
        if gameState.singleGameState.showHelp { helpButton.isHidden = false }
        
        topButton.setTitle(K.Labels.Buttons.trust, for: .normal)
        topButton.backgroundColor = K.Colors.Buttons.trueAnswer
        topButton.isHidden = false
        
        middleButton.setTitle(K.Labels.Buttons.doubt, for: .normal)
        middleButton.backgroundColor = K.Colors.Buttons.doubtAnswer
        middleButton.isHidden = false
        
        bottomButton.setTitle(K.Labels.Buttons.notTrust, for: .normal)
        bottomButton.sound = nil
        bottomButton.backgroundColor = K.Colors.Buttons.falseAnswer
        bottomButton.isHidden = false
        
        reloadTexts(question: question, comment: comment)
    }
    func showUIWaitMode(question: String, comment: String) {
        showAnswer(question: question, comment: comment)
        topButton.isHidden = true
        middleButton.isHidden = true
        bottomButton.isHidden = true
        helpButton.isHidden = true
        
        bottomButton.setTitle(K.Labels.Buttons.nextQuestion, for: .normal)
        bottomButton.turnClickSoundOn(sound: K.Sounds.page)
        bottomButton.backgroundColor = K.Colors.foreground
        bottomButton.isHidden = false
    }
    func showUIFinishGame(question: String, comment: String) {
        showAnswer(question: question, comment: comment)
        topButton.isHidden = true
        middleButton.isHidden = true
        bottomButton.isHidden = true
        helpButton.isHidden = true
        
        bottomButton.setTitle(K.Labels.Buttons.showResults, for: .normal)
        bottomButton.backgroundColor = K.Colors.foreground
        bottomButton.isHidden = false
    }
    func showUIResults(fullResultsText: String, shortResultsText: String) {
        hideAnswer()
        helpButton.isHidden = true
        bottomButton.setTitle(K.Labels.Buttons.finishGame, for: .normal)
        bottomButton.isHidden = false
        questionText.text = fullResultsText
        questionText.isHidden = false
        resultLabel.text = shortResultsText
        resultLabel.backgroundColor = K.Colors.ResultBar.trueAnswer
        resultLabel.isHidden = false
        K.Sounds.applause?.resetAndPlay(startVolume: 1, fadeDuration: nil)
        bottomButton.turnClickSoundOn(sound: K.Sounds.click)
    }
    func reloadTexts(question: String, comment: String) {
        if gameState.singleGameState.answerState != .gotResults {
            questionText.text = question //self.questionsPack.questionTasks[self.gameState.singleGameState.currentNumber].question
        }
        commentText.text = comment //questionsPack.questionTasks[gameState.singleGameState.currentNumber].comment
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.questionText.flashScrollIndicators()
        })
        let title = "\(K.Labels.Titles.question)\(gameState.singleGameState.currentNumber+1)/\(questionsPack.questionTasks.count)"
        setScoreTitle(title: title, score: gameState.singleGameState.score)
    }
}