import UIKit

final class StudyPlanViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private(set) weak var textFieldCourse: UITextField!
    @IBOutlet private(set) weak var textFieldSection: UITextField!
    @IBOutlet private(set) weak var dpDate: UIDatePicker!
    
    // MARK: - Properties
    private let studyManager = StudyManager.shared
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions
    @IBAction func schedule(_ sender: UIButton) {
		let id = UUID().uuidString
        let studyPlan = StudyPlan(course: textFieldCourse.text!,
								  section: textFieldSection.text!,
								  date: dpDate.date,
								  done: false,
								  id: id)
        studyManager.addPlan(studyPlan)
        navigationController!.popViewController(animated: true)
    }
    
}
