import logging
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

# Setup logger
logger = logging.getLogger(__name__)

# Display navigation links
SideBarLinks(show_home=True)


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
st.header("Post a New Review")
rating = st.number_input("Rating (1-5):", min_value=1, max_value=5, step=1)
description = st.text_area("Description:", max_chars=500)

st.write("Select which company:")
desired_company = ui.select(
    options=list(company_options.keys()), 
    label="Select which company:", 
    key="desired_company_select"
)
desired_company_id = company_options.get(desired_company)

st.write("Job Position:")
selected_job_title = ui.select(
    options=list(job_position_options.keys()), 
    label="Job Position:", 
    key="job_position_select"
)
selected_job_position_id = job_position_options.get(selected_job_title)


saveBtn = ui.button("Submit Review", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key="submit_review_btn")

# Function to post the review to the server
def postReview(rating, description, student_name, student_id, job_position_id):
    try:
        # Review data to be sent to the API
        review_data = {
            "rating": rating,
            "review": description,
            "student_name": student_name,
            "student_id": student_id,
            "job_position_id": job_position_id
        }

        response = requests.post('http://api:4000/r/reviews', json=review_data)

        if response.status_code == 200:
            logger.info("Review posted successfully.")
            st.success("Review posted successfully!")
            st.switch_page('pages/See_Reviews.py')  # Optional: Navigate to the reviews page after posting
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to post review: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key="post_review_error"
            )
    except Exception as e:
        logger.error(f"Error posting review: {str(e)}")
        ui.element(
            "p",
            children=["Failed to post review: Unknown error"],
            className="text-red-500",
            key="post_review_error"
        )

# If the save button is pressed, submit the review
if saveBtn:
    if rating and description and selected_job_position_id:
        postReview(rating, description, 'Wade Wilson', 1, selected_job_position_id)
    else:
        st.error("Please fill in all the fields to submit your review.")