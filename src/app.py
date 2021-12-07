import os
import json
import numpy as np
from openvino.inference_engine import IECore

input_directory = os.environ['IEXEC_IN']
output_directory = os.environ['IEXEC_OUT']

if __name__ == '__main__':
    ie = IECore()
    result = {}
    try:
        input_filename = os.environ['IEXEC_DATASET_FILENAME']
        result['input_filename'] = input_filename
        input_path = os.path.join(input_directory, input_filename)
        result['input_path'] = input_path
        file_size = os.path.getsize(input_path)
        result['file_size'] = file_size
        net_onnx = ie.read_network(model=input_path)
        result['read_network'] = True
        exec_net_onnx = ie.load_network(network=net_onnx, device_name="CPU")
        result['load_network'] = True
        inputInfo = str(exec_net_onnx.input_info)
        outputInfo = str(exec_net_onnx.outputs)
        result['inputInfo'] = inputInfo
        result['outputInfo'] = outputInfo
    except Exception:
        result['error'] = "Input file not loaded"

    print(result)

    with open(os.path.join(output_directory, "result.json"), 'w+') as f:
        json.dump(result, f)
    with open(os.path.join(output_directory, "computed.json"), 'w+') as f:
        json.dump(
            {"deterministic-output-path": os.path.join(output_directory, "result.json")}, f)
