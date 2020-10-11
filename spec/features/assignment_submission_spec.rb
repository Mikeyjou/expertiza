describe "assignment submisstion test" do
  before(:each) do
    # create assignment and topic
    create(:assignment, name: "Assignment1684", directory_path: "Assignment1684")
    create_list(:participant, 3)
    create(:topic, topic_name: "Topic")
    create(:deadline_type, name: "submission")
    create(:deadline_type, name: "review")
    create(:deadline_type, name: "metareview")
    create(:deadline_type, name: "drop_topic")
    create(:deadline_type, name: "signup")
    create(:deadline_type, name: "team_formation")
    create(:deadline_right)
    create(:deadline_right, name: 'Late')
    create(:deadline_right, name: 'OK')
    create(:assignment_due_date, deadline_type: DeadlineType.where(name: "submission").first, due_at: DateTime.now.in_time_zone + 1.day)
  end

  def signup_topic
    user = User.find_by(name: "student2064")
    stub_current_user(user, user.role.name, user.role)
    visit '/student_task/list'
    visit '/sign_up_sheet/sign_up?id=1&topic_id=1' # signup topic
    visit '/student_task/list'
    click_link "Assignment1684"
    click_link "Your work"
  end

  it "is able to submit a single valid link" do
    signup_topic
    fill_in 'submission', with: "https://www.ncsu.edu"
    click_on 'Upload link'
    expect(page).to have_content "https://www.ncsu.edu"
    # open the link and check content
    click_on "https://www.ncsu.edu"
    expect(page).to have_http_status(200)
  end

  it "should not submit invalid link" do
    skip('the error depends on the dns server. For spectrum network provider, invalid url will redirect to http://www.dnsrsearch.com')
    signup_topic
    # invalid format url1
    fill_in 'submission', with: "wolfpack"
    click_on 'Upload link'
    expect(page).to have_content "The URL or URI is invalid"
  end

  it "is able to submit multiple valid links" do
    signup_topic
    fill_in 'submission', with: "https://www.ncsu.edu"
    click_on 'Upload link'
    fill_in 'submission', with: "https://www.google.com"
    click_on 'Upload link'
    fill_in 'submission', with: "https://bing.com"
    click_on 'Upload link'
    expect(page).to have_content "https://www.ncsu.edu"
    expect(page).to have_content "https://www.google.com"
    expect(page).to have_content "https://bing.com"
  end

  it "should not submit duplicated link" do
    signup_topic
    fill_in 'submission', with: "https://google.com"
    click_on 'Upload link'
    expect(page).to have_content "https://google.com"
    fill_in 'submission', with: "https://google.com"
    click_on 'Upload link'
    expect(page).to have_content "You or your teammate(s) have already submitted the same hyperlink."
  end

  it "submit empty link" do
    signup_topic
    # hyperlink is empty
    fill_in 'submission', with: ""
    click_on 'Upload link'
    expect(page).to have_content "The URL or URI is invalid. Reason: The hyperlink cannot be empty!"
    # hyperlink is "http://"
    fill_in 'submission', with: "http://"
    click_on 'Upload link'
    expect(page).to have_content "The URL or URI is invalid."
  end

  it "is able to submit single valid file" do
    signup_topic
    file_path = Rails.root + "spec/features/assignment_submission_txts/valid_assignment_file.jpg"
    attach_file('uploaded_file', file_path)
    click_on 'Upload file'
    expect(page).to have_content "valid_assignment_file.jpg"

    # check content of the uploaded file
    file_upload_path = Rails.root + "pg_data/instructor6/csc517/test/Assignment1684/0/valid_assignment_file.jpg"
    expect(File).to exist(file_upload_path)
    expect(File.open(file_upload_path, 'rb').read).to eql File.open(file_path, 'rb').read
  end

  it "is able to submit multiple valid files" do
  end

  it "is able to update already uploaded file" do
  end
end
