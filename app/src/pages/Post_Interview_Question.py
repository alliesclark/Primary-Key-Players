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


# Form to post a new review
st.header("Post an Interview Question")
question = st.text_area("Question:", max_chars=500)

st.write("Select the job position this question applied to:")
selected_job_title = ui.select(options=list(job_position_options.keys()), label="Select Job Position:")
selected_job_position_id = job_position_options.get(selected_job_title)

saveBtn = ui.button("Submit Question", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key="submit_question_btn")

# Function to post the review to the server
def postQuestion(question, job_position_id, author_id):
    try:
        # Review data to be sent to the API
        question_data = {
            "question": question,
            "job_position_id": job_position_id,
            "author_id": author_id
        }

        response = requests.post('http://api:4000/i/interview_questions', json=question_data)

        if response.status_code == 200:
            logger.info("Question posted successfully.")
            st.success("Question posted successfully!")
            st.switch_page('pages/Research_Interview_Questions.py')  # Optional: Navigate to the reviews page after posting
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to post question: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key="post_review_error"
            )
    except Exception as e:
        logger.error(f"Error posting question: {str(e)}")
        ui.element(
            "p",
            children=["Failed to post question: Unknown error"],
            className="text-red-500",
            key="post_review_error"
        )

# If the save button is pressed, submit the review
if saveBtn:
    if question and selected_job_position_id:
        postQuestion(question, selected_job_position_id, 2)
    else:
        st.error("Please fill in all the fields to post this question.")