# frozen_string_literal: true

class SubmitQuiz
  def initialize(quiz, answers, user)
    @quiz = quiz
    @answers = answers
    @user = user
  end

  def call
    @quiz_answer = create_quiz_answer
    @answers.each do |answer|
      process_answer(answer)
    end
    @quiz_answer
  end

  private

  def process_answer(answer)
    question = @quiz.questions.find_by(id: answer['question_id'])
    return unless question

    answer_ids = answer['answer_ids']
    return if question.single_answer? && answer_ids.size > 1

    score = calculate_score(question, answer_ids)
    update_final_score(score)
    add_answer_in_quiz_answer(question, answer_ids, score)
  end

  def update_final_score(score)
    @quiz_answer.final_score += score
  end

  def calculate_score(question, answer_ids)
    if question.single_answer?
      calculate_single_answer_score(question, answer_ids.first)
    else
      calculate_multiple_answer_score(question, answer_ids)
    end
  end

  def calculate_multiple_answer_score(question, answer_ids)
    correct_answer_choices_ids = question.answer_choices.where(correct: true).pluck(:id).map(&:to_s)
    wrong = (answer_ids - correct_answer_choices_ids).size
    right = (answer_ids & correct_answer_choices_ids).size
    -(question.incorrectness_weight * wrong) + (question.correctness_weight * right)
  end

  def calculate_single_answer_score(question, answer_id)
    score = 0
    ans = question.answer_choices.find_by(id: answer_id)
    return 0 unless ans

    if ans.correct == true
      score += question.correctness_weight
    else
      score -= question.incorrectness_weight
    end
    score
  end

  def create_quiz_answer
    @quiz_answer = QuizAnswer.new
    @quiz_answer.quiz = @quiz
    @quiz_answer.user_id = @user.id.to_s
    @quiz_answer.user_email = @user.email
    @quiz_answer.final_score = 0
    @quiz_answer.answers = []
    @quiz_answer
  end

  def add_answer_in_quiz_answer(question, answer_ids, score)
    @quiz_answer.answers.push({
                                question_id: question.id.to_s,
                                question_text: question.title,
                                answer_ids:,
                                score:
                              })
  end
end
