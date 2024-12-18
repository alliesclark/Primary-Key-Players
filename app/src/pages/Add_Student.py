import logging
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

# Setup logger
logger = logging.getLogger(__name__)

# Display navigation links
SideBarLinks(show_home=True)


# Intro section for the add student page
with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="add_student_card"):
    ui.element("h2", children=["Add Student Information"], className="text-2xl font-bold text-gray-800", key="add_student_title")
    ui.element("div", children=["\n\n"], key="add_student_divider")

#Creat list of majors for dropdown menu
majors = []
try:
    majors = requests.get('http://api:4000/m/majors').json()
except Exception as e:
    logger.error(f"Error retrieving company data: {e}")
    majors = []

major_options = {major['name']: major["id"] for major in majors}

#Create list of advisors for dropdown menu
advisors = []
try:
    advisors = requests.get('http://api:4000/ad/advisors').json()
        
except Exception as e:
    logger.error(f"Error retrieving company data: {e}")
    advisors = []

advisor_options = {advisor['name']: advisor['id'] for advisor in advisors}

# Form to add a new student
name = st.text_input("Name:")
email = st.text_input("Email:")
gpa = st.text_input("GPA:")
st.write("Select major:\n")
desired_major = ui.select(options=list(major_options.keys()), label="Select major:", key="major_select")
major_id = major_options.get(desired_major)
# major_id = st.text_input("Major ID:")
grad_year = st.text_input("Graduation Year:")
st.write("Select advisor:\n")
desired_advisor = ui.select(options=list(advisor_options.keys()), label="Select advisor:", key="advisor_select")
advised_by = advisor_options.get(desired_advisor)

saveBtn = ui.button("Submit Student Information", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key="submit_student_btn")

# Function to post the student to the server
def addStudent(name, email, gpa, major_id, grad_year, advised_by):
    try:
        # Student data to be sent to the API
        student_data = {
            "name": name,
            "email": email,
            "gpa": gpa,
            "major_id": major_id,
            "grad_year": grad_year,
            "advised_by": advised_by,
        }

        response = requests.post('http://api:4000/s/students', json=student_data)

        if response.status_code == 200:
            logger.info("Student added successfully.")
            st.success("Student added successfully!")
            st.switch_page('pages/Student_Profiles.py')  # Optional: Navigate to the students page after adding
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to add student: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key="add_student_error"
            )
    except Exception as e:
        logger.error(f"Error adding student: {str(e)}")
        ui.element(
            "p",
            children=["Failed to add student: Unknown error"],
            className="text-red-500",
            key="add_student_error"
        )

# If the save button is pressed, submit the student information
if saveBtn:
    if name and email and gpa and major_id and grad_year and advised_by:
        addStudent(name, email, gpa, major_id, grad_year, advised_by)
    else:
        st.error("Please fill in all the fields to add this student.")