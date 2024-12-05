import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

#Intro section for update review page
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="edit_review_card"):
    ui.element("h2", children=["Edit Review"], className="text-2xl font-bold text-gray-800", key="edit_review_title")
    ui.element("div", children=["\n\n"], key="edit_review_profiles_divider")
    ui.element("p", children=["Update review information below."], className="text-gray-600")

#Retrieve the information of the specific review
data = {} 
try:
    data = requests.get("http://api:4000/r/reviews/" + str(st.session_state['updating_review_id'])).json()
    logger.info(f"Retrieved review data: {data}")
    ui.element("h3", children=["Reviews"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    
#Update the review's information in the database
def updateReview(review_id, updated_data):
    try:
        response = requests.put(
            f'http://api:4000/r/reviews/{review_id}', 
            json=updated_data
        )
        
        if response.status_code == 200:
            logger.info(f"Review updated successfully: {review_id}")
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to update review: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"update_review_error_{review_id}"
            )
    except Exception as e:
        logger.error(f"Error updating review: {str(e)}")
        ui.element(
            "p",
            children=[
                "Failed to update review: Unknown error"
            ],
            className="text-red-500",
            key=f"update_review_error_{review_id}"
        )

#Display review's information as editable fields
def UpdateReviewCard(review):
    job_positions = []
    try:
        job_positions = requests.get('http://api:4000/j/job-position').json()
    except Exception as e:
        logger.error(f"Error retrieving job positions data: {e}")
        job_positions = []

    job_position_options = {job['title']: job["id"] for job in job_positions}

    companies = []
    try:
        companies = requests.get('http://api:4000/c/company').json()
    except Exception as e:
        logger.error(f"Error retrieving company data: {e}")
        companies = []

    company_options = {company['name']: company["id"] for company in companies}

    # Form to post a new review
    st.header("Review:")
    updated_rating = st.number_input("Rating (1-5):", min_value=1, max_value=5, step=1)
    updated_description = st.text_area("Description:", value= review['review'], max_chars=500)

    st.write("Company:")
    desired_company = ui.select(
        options=list(company_options.keys()), 
        label="Select which company:", 
        key="desired_company_select"
    )
    updated_company_id = company_options.get(desired_company)

    st.write("Job Position:")
    selected_job_title = ui.select(
        options=list(job_position_options.keys()), 
        label="Job Position:", 
        key="job_position_select"
)
    updated_job_position_id = job_position_options.get(selected_job_title)

    # Question: Would you like to be contacted?
    contact_preference = st.radio(
        "Would you like to be contacted?",
        options=["No", "Yes"],
        key="contact_preference"
    )

    # Show email input field if user selects "Yes"
    contact_email = None
    if contact_preference == "Yes":
        contact_email = st.text_input("Add the email you would like to be contacted with:")

    saveBtn = ui.button("Save", className="bg-blue-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"save_review_{review['id']}")
    #If save button is clicked, student information is updated
    if saveBtn:
        updated_data = {
            "rating": updated_rating,
            "review": updated_description,
            "job_position_id": updated_job_position_id,
        }
        try:
            updateReview(review['id'], updated_data)
            st.success("Review updated successfully!")
            st.switch_page('pages/Manage_Reviews.py')
        except Exception as e:
            st.error(f"Error updating review: {str(e)}")

#Displays student information
if data:
    UpdateReviewCard(data[0])
    