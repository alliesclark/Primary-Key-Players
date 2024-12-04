import logging
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

# Setup logger
logger = logging.getLogger(__name__)

# Display navigation links
SideBarLinks(show_home=True)


# Intro section for the add job posting page
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="add_job_card"):
    ui.element("h2", children=["Add Job Information"], className="text-2xl font-bold text-gray-800", key="add_job_title")
    ui.element("div", children=["\n\n"], key="add_job_divider")

# Form to add a new job posting
company_id = st.text_input("Company ID:")
title = st.text_input("Title:")
description = st.text_area("Description:", max_chars=500)
location = st.text_input("Location:")
desired_skills = st.text_input("Desired Skills:")
targeted_majors = st.text_input("Targeted Majors:")

saveBtn = ui.button("Submit Job Posting", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key="submit_job_btn")

# Function to post the review to the server
def addJob(title, description, desired_skills, location, targeted_majors, company_id):
    try:
        # Review data to be sent to the API
        job_data = {
            "title": title,
            "description": description,
            "location" : location,
            "desired_skills": desired_skills,
            "targeted_majors": targeted_majors,
            "company_id": company_id,
        }

        response = requests.post('http://api:4000/j/job-position', json=job_data)

        if response.status_code == 200:
            logger.info("Job Posting added successfully.")
            st.success("Job Posting added successfully!")
            st.switch_page('pages/Manage_Job_Postings.py')  # Optional: Navigate to the job postings page after adding
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to add job posting: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key="add_job_error"
            )
    except Exception as e:
        logger.error(f"Error adding job posting: {str(e)}")
        ui.element(
            "p",
            children=["Failed to add job posting: Unknown error"],
            className="text-red-500",
            key="add_job_error"
        )

# If the save button is pressed, submit the review
if saveBtn:
    if title and description and desired_skills and targeted_majors and location and company_id:
        addJob(title, description, desired_skills, location, targeted_majors, company_id)
    else:
        st.error("Please fill in all the fields to add this job posting.")