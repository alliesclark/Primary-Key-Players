import logging
logger = logging.getLogger(__name__)
import streamlit as st
import streamlit_shadcn_ui as ui
import requests

from modules.nav import SideBarLinks

SideBarLinks(show_home=True)

with ui.element("div", className="flex flex-col border rounded-lg shadow p-4 m-2", key="view_student_card"):
    ui.element("h2", children=["Manage Students"], className="text-2xl font-bold text-gray-800", key="view_students_title")
    ui.element("div", children=["\n\n"], key="view_student_profiles_divider")
    ui.element("p", children=["View, add, update, and delete student profiles."], className="text-gray-600")

data = {} 
try:
    data = requests.get('http://api:4000/s/students').json()
except:
    logger.error("Error retrieving data from the API")
    data = []  
    
def deleteStudent(student):
    try:
        response = requests.delete(f'http://api:4000/s/students/{student["id"]}')
        if response.status_code == 200:
            logger.info(f"Student deleted {student['id']}")    
        else:
            ui.element(
                "p",
                children=[
                    f"Failed to delete student: {response.json().get('message', 'Unknown error')}"
                ],
                className="text-red-500",
                key=f"delete_student_error_{student['id']}"
            )
    except:
        logger.error("Error deleting student")
        ui.element(
            "p",
            children=[
                f"Failed to delete student: Unknown error"
            ],
            className="text-red-500",
            key=f"delete_student_error_{student['id']}"
        )

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

def StudentProfileCard(student):
    with ui.element("div", key=f"recruiter_card_{student['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
        ui.element("h3", children=[f"{student['name']}"], className="text-xl font-bold text-gray-800", key=f"student_name_{student['id']}")
  
# def StudentProfileCard(student):
#     with ui.element("div", key=f"student_card_{student['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
#         ui.element(
#             "h3",
#             children=[f"Name: {student['name']}"],
#             className="text-xl font-bold text-gray-800",
#             key=f"student_profiles_{student['id']}"
#         )

#         ui.element(
#             "p",
#             children=[f"Email: {student['email']}"],
#             className="text-gray-600",
#             key=f"student_profiles_{student['id']}"
#         )

#         ui.element(
#             "p",
#             children=[f"GPA: {student['gpa']}"],
#             className="text-gray-600",
#             key=f"student_profiles_{student['id']}"
#         )

#         ui.element(
#             "p",
#             children=[f"Email: {student['email']}"],
#             className="text-gray-600",
#             key=f"student_profiles_{student['id']}"
#         )

#         ui.element(
#             "p",
#             children=[f"Major: {student['major_name']}"],
#             className="text-gray-600",
#             key=f"student_profiles_{student['id']}"
#         )

#         ui.element(
#             "p",
#             children=[f"Grad Year: {student['grad_year']}"],
#             className="text-gray-600",
#             key=f"student_profiles_{student['id']}"
#         )

#         ui.element(
#             "p",
#             children=[f"Advised By: {student['advisor_name']}"],
#             className="text-gray-400 text-sm",
#             key=f"student_profiles_{student['id']}"
#         )

#         updateBtn = ui.button("Update", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"update_student_{student['id']}")
#         if updateBtn:
#             updateStudent(student)
#         ui.alert_dialog(show=deleteBtn, title="Deleted Student", description=f"The student profile under the name {student['name']} has been deleted.", confirm_label="OK", cancel_label="Cancel", key=f"alert_dialog_{student['id']}")

        
#         deleteBtn = ui.button("Delete", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"delete_student_{student['id']}")
#         if deleteBtn:
#             deleteStudent(student)
#         ui.alert_dialog(show=deleteBtn, title="Deleted Student", description=f"The student profile under the name {student['name']} has been deleted.", confirm_label="OK", cancel_label="Cancel", key=f"alert_dialog_{student['id']}")

# def StudentProfileCard(student):
#     # Track whether the card is in edit mode
#     edit_mode = st.session_state.get(f"edit_mode_{student['id']}", False)

#     with ui.element("div", key=f"student_card_{student['id']}", className="p-4 m-2 shadow-lg rounded-lg border"):
#         if edit_mode:
#             # Editable fields
#             updated_name = ui.input(
#                 label="Name", 
#                 value=student['name'], 
#                 key=f"update_name_{student['id']}"
#             )
#             updated_email = ui.input(
#                 label="Email", 
#                 value=student['email'], 
#                 key=f"update_email_{student['id']}"
#             )
#             updated_gpa = ui.input(
#                 label="GPA", 
#                 value=str(student['gpa']), 
#                 key=f"update_gpa_{student['id']}"
#             )
#             updated_major = ui.input(
#                 label="Major", 
#                 value=student['major_name'], 
#                 key=f"update_major_{student['id']}"
#             )
#             updated_grad_year = ui.input(
#                 label="Grad Year", 
#                 value=str(student['grad_year']), 
#                 key=f"update_grad_year_{student['id']}"
#             )
#             updated_advisor = ui.input(
#                 label="Advised By", 
#                 value=student['advisor_name'], 
#                 key=f"update_advisor_{student['id']}"
#             )

#             # Save and Cancel buttons
#             saveBtn = ui.button("Save", className="bg-green-500 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"save_student_{student['id']}")
#             cancelBtn = ui.button("Cancel", className="bg-gray-500 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"cancel_edit_{student['id']}")

#             if saveBtn:
#                 updated_data = {
#                     "id": student['id'],  # Ensure the student ID is included for updating
#                     "name": updated_name.get_value(),
#                     "email": updated_email.get_value(),
#                     "gpa": float(updated_gpa.get_value()),
#                     "major_name": updated_major.get_value(),
#                     "grad_year": int(updated_grad_year.get_value()),
#                     "advisor_name": updated_advisor.get_value()
#                 }
#                 updateStudent(student, updated_data)
#                 st.session_state[f"edit_mode_{student['id']}"] = False

#             if cancelBtn:
#                 st.session_state[f"edit_mode_{student['id']}"] = False
#         else:
#             # Display static fields
#             ui.element("h3", children=[f"Name: {student['name']}"], className="text-xl font-bold text-gray-800")
#             ui.element("p", children=[f"Email: {student['email']}"], className="text-gray-600")
#             ui.element("p", children=[f"GPA: {student['gpa']}"], className="text-gray-600")
#             ui.element("p", children=[f"Major: {student['major_name']}"], className="text-gray-600")
#             ui.element("p", children=[f"Grad Year: {student['grad_year']}"], className="text-gray-600")
#             ui.element("p", children=[f"Advised By: {student['advisor_name']}"], className="text-gray-400 text-sm")

#             # Update button
#             updateBtn = ui.button("Update", className="bg-blue-500 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"update_student_{student['id']}")
#             if updateBtn:
#                 st.session_state[f"edit_mode_{student['id']}"] = True

#         # Delete button
#         deleteBtn = ui.button("Delete", className="bg-red-400 text-white font-bold py-2 px-4 rounded-lg shadow", key=f"delete_student_{student['id']}")
#         if deleteBtn:
#             deleteStudent(student)
#             ui.alert_dialog(
#                 show=True, 
#                 title="Deleted Student", 
#                 description=f"The student profile under the name {student['name']} has been deleted.", 
#                 confirm_label="OK", 
#                 cancel_label="Cancel", 
#                 key=f"alert_dialog_{student['id']}"
#             )



if data and isinstance(data, list):
    if data:
        for student in data:
            StudentProfileCard(student)
    else:
        ui.element("h3", children=["No students found."], className="text-xl font-bold text-gray-800")
else:
    ui.element("h3", children=["No students found."], className="text-xl font-bold text-gray-800")


    