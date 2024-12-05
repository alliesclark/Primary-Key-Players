import logging
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

# Setup logger
logger = logging.getLogger(__name__)

# Display navigation links
SideBarLinks(show_home=True)


# Intro section for the review posting page
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="post_review_card"):
    ui.element("h2", children=["Post a Review"], className="text-2xl font-bold text-gray-800", key="post_review_title")
    ui.element("div", children=["\n\n"], key="post_review_divider")
    

# Form to post a new review
st.header("Post a New Review")
rating = st.number_input("Rating (1-5):", min_value=1, max_value=5, step=1)
description = st.text_area("Description:", max_chars=500)
student_name = st.text_input(f"Your Name (Student): ")
student_id = st.text_input(f"Your Student ID: ")
job_position = st.text_input("Job Position (e.g., Software Engineer):")

saveBtn = ui.button("Submit Review", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key="submit_review_btn")

# Function to post the review to the server
def postReview(rating, description, student_name, student_id, job_position):
    try:
        review_data = {
            "rating": rating,
            "review": description,
            "student_name": student_name,
            "student_id": student_id,
            "job_position": job_position
        }

        response = requests.post('http://api:4000/r/reviews', json=review_data)

        if response.status_code == 200:
            logger.info("Review posted successfully.")
            st.success("Review posted successfully!")
            st.switch_page('pages/See_Reviews.py') 
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

if saveBtn:
    if rating and description and student_name and student_id and job_position:
        postReview(rating, description, student_name, student_id, job_position)
    else:
        st.error("Please fill in all the fields to submit your review.")