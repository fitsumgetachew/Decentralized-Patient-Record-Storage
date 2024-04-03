
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract HealthCare {
    struct Doctor {
        string name;
        string qualification;
        string workPlace;
    }
    
    struct Patient {
        string name;
        uint256 age;
        string[] diseases;
    }
    
    struct Medicine {
        uint256 id;
        string name;
        uint256 expiryDate;
        string dose;
        uint256 price;
    }
    
    mapping(address => Doctor) public doctors;
    mapping(address => Patient) public patients;
    mapping(uint256 => Medicine) public medicines;
    mapping(address => uint256[]) public patientMedicines;

    // Events
    event DoctorRegistered(address indexed doctorAddress, string name, string qualification, string workPlace);
    event PatientRegistered(address indexed patientAddress, string name, uint256 age);
    event DiseaseAdded(address indexed patientAddress, string disease);
    event MedicineAdded(uint256 indexed id, string name, uint256 expiryDate, string dose, uint256 price);
    event MedicinePrescribed(address indexed doctorAddress, address indexed patientAddress, uint256 indexed medicineId);
    event PatientDetailsUpdated(address indexed patientAddress, uint256 newAge);

    // Function to register a new doctor
    function registerDoctor(string memory _name, string memory _qualification, string memory _workPlace) public {
        doctors[msg.sender] = Doctor(_name, _qualification, _workPlace);
        emit DoctorRegistered(msg.sender, _name, _qualification, _workPlace);
    }

    // Function to register a new patient
    function registerPatient(string memory _name, uint256 _age) public {
        patients[msg.sender] = Patient(_name, _age, new string[](0));
        emit PatientRegistered(msg.sender, _name, _age);
    }

    // Function to add a patient's disease
    function addDisease(string memory _disease) public {
        patients[msg.sender].diseases.push(_disease);
        emit DiseaseAdded(msg.sender, _disease);
    }

    // Function to add medicine
    function addMedicine(uint256 _id, string memory _name, uint256 _expiryDate, string memory _dose, uint256 _price) public {
        medicines[_id] = Medicine(_id, _name, _expiryDate, _dose, _price);
        emit MedicineAdded(_id, _name, _expiryDate, _dose, _price);
    }

    // Function to prescribe medicine
    function prescribeMedicine(uint256 _id, address _patient) public {
        require(medicines[_id].id != 0, "Medicine does not exist");
        patientMedicines[_patient].push(_id);
        emit MedicinePrescribed(msg.sender, _patient, _id);
    }

    // Function to update patient details by patient
    function updatePatientDetails(uint256 _age) public {
        patients[msg.sender].age = _age;
        emit PatientDetailsUpdated(msg.sender, _age);
    }

    // Function to view patient data
    function viewPatientData(address _patient) public view returns (string memory, uint256, string[] memory) {
        return (patients[_patient].name, patients[_patient].age, patients[_patient].diseases);
    }

    // Function to view medicine details
    function viewMedicineDetails(uint256 _id) public view returns (string memory, uint256, string memory, uint256) {
        return (medicines[_id].name, medicines[_id].expiryDate, medicines[_id].dose, medicines[_id].price);
    }

    // Function to view patient data by a doctor
    function viewPatientDataByDoctor(address _patient) public view returns (string memory, uint256, string[] memory) {
        require(msg.sender != _patient, "Doctor cannot view own data");
        return viewPatientData(_patient);
    }

    // Function to view prescribed medicine to the patient
    function viewPrescribedMedicineToPatient(address _patient) public view returns (uint256[] memory) {
        return patientMedicines[_patient];
    }

    // Function to view doctor details
    function viewDoctorDetails(address _doctor) public view returns (string memory, string memory, string memory) {
        return (doctors[_doctor].name, doctors[_doctor].qualification, doctors[_doctor].workPlace);
    }
}
