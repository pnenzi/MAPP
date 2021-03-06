#include "vcvsModSpec.h"

// the following includes/usings needed for boost::assign
// which provides: vector<T> oof; oof += 1, 2, 3, 4; (!)
// see http://www.boost.org/doc/libs/1_39_0/libs/assign/doc/index.html
#include <boost/assign/std/vector.hpp> // for 'operator+=()'
#include <boost/assert.hpp>
using namespace std;
using namespace boost::assign; // bring 'operator+=()' into scope

// constructor
vcvsModSpec::vcvsModSpec() {
	// model_name
	model_name = "Voltage-controlled voltage source";

	// element_name
	element_name = "undefined"; // TODO: should get is from outside

	// parm_names
	parm_names += "gain";
	
	// parm_defaultvals
	parm_defaultvals += 1.0;

	// parm_vals
	parm_vals = parm_defaultvals;

	// node_names
	node_names += "p", "n", "pc", "nc";
	
	// refnode_name
	refnode_name = "nc";
	
	// explicit_output_names
	explicit_output_names += "ipcnc", "vnnc", "innc";
	
	// the following function sets up refnode_index, io_names, otherio_names, io_types
	// io_nodenames, otherio_types, otherio_nodenames, otherio_nodeindices, explicit_output_types,
	// explicit_output_nodenames, and explicit_output_nodeindices.  It uses node_names, refnode_name and 
	// explicit_output_names - make sure these are set up correctly before calling it.
	setup_ios_otherios_types_nodenames_indices();
}

template <typename TOUT, typename TX, typename TY, typename TU>
  vector<TOUT> vcvsModSpec::fe_tmpl(vector<TX>& vecX, vector<TY>& vecY, vector<TU>& vecU) {
	TX vpnc = vecX[0];
	TX vpcnc = vecX[1];
	TX ipnc = vecX[2];
	double gain = this->parm_vals[0];
	vector<TOUT> out;
	out += 0, -gain*vpcnc + vpnc, -ipnc;
	return out;
}

template <typename TOUT, typename TX, typename TY>
  vector<TOUT> vcvsModSpec::qe_tmpl(vector<TX>& vecX, vector<TY>& vecY) {
	vector<TOUT> out;
	out += 0, 0, 0;
	return out;
}

template <typename TOUT, typename TX, typename TY, typename TU>
  vector<TOUT> vcvsModSpec::fi_tmpl(vector<TX>& vecX, vector<TY>& vecY, vector<TU>& vecU) {
	vector<TOUT> out;
	return out;
}

template <typename TOUT, typename TX, typename TY>
  vector<TOUT> vcvsModSpec::qi_tmpl(vector<TX>& vecX, vector<TY>& vecY) {
	vector<TOUT> out;
	return out;
}

// the "class factories" for accessing this device via dlopen
extern "C" ModSpec_Element* create() {
    return new vcvsModSpec;
}

extern "C" void destroy(ModSpec_Element* p) {
    delete p;
}
