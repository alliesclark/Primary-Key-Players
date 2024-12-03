import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="edit_student_card"):
    ui.element("h2", children=["Manage Student Profile"], className="text-2xl font-bold text-gray-800", key="edit_students_title")
    ui.element("div", children=["\n\n"], key="edit_student_profiles_divider")
    ui.element("p", children=["Edit student profile."], className="text-gray-600")

data = {} 
try:
    data = requests.get("http://api:4000/s/students/" + str(st.session_state['id'])).json()
    ui.element("h3", children=["Student"], className="text-xl font-bold text-gray-800")  
except:
    logger.error("Error retrieving data from the API")
    data = []  
    


def updateStudent(student, updated_data):
    try:
        response = requests.put(
            f'http://api:4000/s/students', 
            json=updated_data
        )
        
        if response.status_code == 200:
            logger.info(f"Student updated successfully: {student['id']}")
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to update student: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"update_student_error_{student['id']}"
            )
    except Exception as e:
        logger.error(f"Error updating student: {str(e)}")
        ui.element(
            "p",
            children=[
                "Failed to update student: Unknown error"
            ],
            className="text-red-500",
            key=f"update_student_error_{student['id']}"
        )

def UpdateProfileCard(student):
    st.header("Edit Student Profile")
    updated_name = st.text_input("Name:", value=student['name'])
    updated_email = st.text_input("Email:", value=student['email'])
    updated_gpa = st.text_input("GPA:", value=student['gpa'])
    # majors = []
    # try:
    #     majors = requests.get('http://api:4000/m/majors').json()
    # except Exception as e:
    #     logger.error(f"Error retrieving company data: {e}")
    #     majors = []

    # major_options = {major['name']: major["id"] for major in majors}
    # desired_major = ui.select(options=list(major_options.keys()), label="Select a major:")
    # desired_major_id = major_options.get(desired_major)
    # st.session_state['major'] = desired_major_id

    updated_major = st.text_input("Major:", value=student['major_name'])
    updated_grad_year = st.number_input("Graduation Year:", value=student['grad_year'], step=1)
    updated_advisor = st.text_input("Advisor:", value=student['advisor_name'])
    # advisors = []
    # try:
    #     advisors = requests.get('http://api:4000/m/majors').json()
    # except Exception as e:
    #     logger.error(f"Error retrieving company data: {e}")
    #     advisors = []

    # advisor_options = {advisor['name']: advisor["id"] for advisor in advisors}
    # desired_major = ui.select(options=list(major_options.keys()), label="Select an advisor:")
    # desired_major_id = major_options.get(desired_major)
    # st.session_state['major'] = desired_major_id

    saveBtn = ui.button("Save", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"save_student_{student['id']}")
    
    if saveBtn:
        updated_data = {
            "id": student['id'],
            "name": updated_name,
            "email": updated_email,
            "gpa": updated_gpa,
            "major_name": updated_major,
            "grad_year": updated_grad_year,
            "advisor_name": updated_advisor,
        }
        try:
            updateStudent(student, updated_data)
            st.success("Profile updated successfully!")
            st.switch_page('pages/Student_Profiles.py')
        except Exception as e:
            st.error(f"Error updating profile: {str(e)}")

# if data and isinstance(data, list):
#     if data:
#         for student in data:
#             if student['id'] == st.session_state['id']:
#                 UpdateProfileCard(student)
#     else:
#         ui.element("h3", children=["No students found."], className="text-xl font-bold text-gray-800")
# else:
#     ui.element("h3", children=["No students found."], className="text-xl font-bold text-gray-800")

if data:
    UpdateProfileCard(data)
    