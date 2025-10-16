from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_mysqldb import MySQL
import MySQLdb.cursors
import config

app = Flask(__name__)
CORS(app)

# ------------------- MySQL Configuration -------------------
app.config['MYSQL_HOST'] = config.MYSQL_HOST
app.config['MYSQL_USER'] = config.MYSQL_USER
app.config['MYSQL_PASSWORD'] = config.MYSQL_PASSWORD
app.config['MYSQL_DB'] = config.MYSQL_DB
app.config['MYSQL_PORT'] = config.MYSQL_PORT
app.config['MYSQL_SSL_MODE'] = "REQUIRED"

mysql = MySQL(app)  # type: ignore


# ------------------- ROOT & TEST -------------------
@app.route('/')
def home():
    return jsonify({"message": "Welcome to the Flask MySQL API!"})


@app.route('/test_connection')
def test_connection():
    try:
        cur = mysql.connection.cursor()  # type: ignore
        cur.execute("SELECT 1")
        cur.close()
        return jsonify({'message': '✅ Connected successfully to MySQL!'})
    except Exception as e:
        return jsonify({'error': str(e)})


# ------------------- POLICYHOLDERS -------------------
@app.route('/policyholders', methods=['GET'])
def get_policyholders():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)  # type: ignore
    # Corrected table name to lowercase
    cur.execute("SELECT * FROM policyholders")
    data = cur.fetchall()
    cur.close()
    return jsonify(data)


@app.route('/policyholders', methods=['POST'])
def add_policyholder():
    data = request.get_json()
    try:
        cur = mysql.connection.cursor()  # type: ignore
        # Corrected table name to lowercase
        cur.execute(
            "INSERT INTO policyholders (name, dob, contact) VALUES (%s, %s, %s)",
            (data['name'], data['dob'], data.get('contact'))
        )
        mysql.connection.commit()  # type: ignore
        new_id = cur.lastrowid
        cur.close()
        return jsonify({'message': 'Policyholder added successfully!', 'policyholder_id': new_id})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@app.route('/policyholders/<int:policyholder_id>', methods=['DELETE'])
def delete_policyholder(policyholder_id):
    try:
        cur = mysql.connection.cursor()  # type: ignore
        # Corrected table name to lowercase
        cur.execute("DELETE FROM policyholders WHERE policyholder_id = %s", (policyholder_id,))
        mysql.connection.commit()  # type: ignore
        cur.close()
        return jsonify({'message': 'Policyholder deleted successfully!'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


# ------------------- POLICIES -------------------
@app.route('/policies', methods=['GET'])
def get_policies():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)  # type: ignore
    # Corrected table names to lowercase
    cur.execute("""
        SELECT p.policy_id, p.policyholder_id, ph.name AS policyholder_name,
               p.premium, p.policy_type
        FROM policy p
        LEFT JOIN policyholders ph ON p.policyholder_id = ph.policyholder_id
    """)
    data = cur.fetchall()
    cur.close()
    return jsonify(data)


@app.route('/policies', methods=['POST'])
def add_policy():
    data = request.get_json()
    try:
        cur = mysql.connection.cursor()  # type: ignore
        # Corrected table name to lowercase
        cur.execute(
            "INSERT INTO policy (policyholder_id, premium, policy_type) VALUES (%s, %s, %s)",
            (data['policyholder_id'], data['premium'], data['policy_type'])
        )
        mysql.connection.commit()  # type: ignore
        new_id = cur.lastrowid
        cur.close()
        return jsonify({'message': 'Policy added successfully!', 'policy_id': new_id})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@app.route('/policies/<int:policy_id>', methods=['DELETE'])
def delete_policy(policy_id):
    try:
        cur = mysql.connection.cursor()  # type: ignore
        # Corrected table name to lowercase
        cur.execute("DELETE FROM policy WHERE policy_id = %s", (policy_id,))
        mysql.connection.commit()  # type: ignore
        cur.close()
        return jsonify({'message': 'Policy deleted successfully!'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


# ------------------- CLAIMS -------------------
@app.route('/claims', methods=['GET'])
def get_claims():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)  # type: ignore
    # Corrected table names to lowercase
    cur.execute("""
        SELECT c.claim_id, c.policy_id, c.claim_date, c.claim_amount, c.status,
               p.policy_type, ph.name AS policyholder_name
        FROM claims c
        LEFT JOIN policy p ON c.policy_id = p.policy_id
        LEFT JOIN policyholders ph ON p.policyholder_id = ph.policyholder_id
    """)
    data = cur.fetchall()
    cur.close()
    return jsonify(data)


@app.route('/claims', methods=['POST'])
def add_claim():
    data = request.get_json()
    try:
        cur = mysql.connection.cursor()  # type: ignore
        # Corrected table name to lowercase
        cur.execute(
            "INSERT INTO claims (policy_id, claim_date, claim_amount, status) VALUES (%s, %s, %s, %s)",
            (data['policy_id'], data['claim_date'], data['claim_amount'], data['status'])
        )
        mysql.connection.commit()  # type: ignore
        new_id = cur.lastrowid
        cur.close()
        return jsonify({'message': 'Claim added successfully!', 'claim_id': new_id})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@app.route('/claims/<int:claim_id>', methods=['DELETE'])
def delete_claim(claim_id):
    try:
        cur = mysql.connection.cursor()  # type: ignore
        # Corrected table name to lowercase
        cur.execute("DELETE FROM claims WHERE claim_id = %s", (claim_id,))
        mysql.connection.commit()  # type: ignore
        cur.close()
        return jsonify({'message': 'Claim deleted successfully!'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


# ------------------- AGENTS -------------------
@app.route('/agents', methods=['GET'])
def get_agents():
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)  # type: ignore
    # Corrected table name to lowercase
    cur.execute("SELECT * FROM agents")
    data = cur.fetchall()
    cur.close()
    return jsonify(data)


@app.route('/agents', methods=['POST'])
def add_agent():
    data = request.get_json()
    try:
        cur = mysql.connection.cursor()  # type: ignore
        # Corrected table name to lowercase
        cur.execute(
            "INSERT INTO agents (agent_name, phone) VALUES (%s, %s)",
            (data['agent_name'], data.get('phone'))
        )
        mysql.connection.commit()  # type: ignore
        new_id = cur.lastrowid
        cur.close()
        return jsonify({'message': 'Agent added successfully!', 'agent_id': new_id})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


@app.route('/agents/<int:agent_id>', methods=['DELETE'])
def delete_agent(agent_id):
    try:
        cur = mysql.connection.cursor()  # type: ignore
        # Corrected table name to lowercase
        cur.execute("DELETE FROM agents WHERE agent_id = %s", (agent_id,))
        mysql.connection.commit()  # type: ignore
        cur.close()
        return jsonify({'message': 'Agent deleted successfully!'})
    except Exception as e:
        return jsonify({'error': str(e)}), 400


# ------------------- RUN APP -------------------
if __name__ == '__main__':
    app.run(debug=True)

