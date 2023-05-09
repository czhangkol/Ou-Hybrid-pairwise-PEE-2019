
Hybrid pairwise PEE
=======


This repo is implementation for the accepted paper "[Improving Pairwise PEE via Hybrid-Dimensional Histogram Generation and  Adaptive Mapping Selection](https://ieeexplore.ieee.org/document/8419757)" (TCSVT 2019).


<p align="center"> <img src="./M1.jpg" width="100%">    </p>
<p align="center"> Figure 1: Flowchart of the method. </p>


<p align="center"> <img src="./M2.jpg" width="100%">    </p>
<p align="center"> Figure 2: General idea for the proposed method using the hybrid PEHs of 1D and high dimensional. </p>

<p align="center"> <img src="./M3.jpg" width="100%">    </p>
<p align="center"> Figure 3: Comparison in the adaptive pixel pairing strategy. </p>

## How to run

```
go to Public_Code
run mian.m
```

## Experimental Results

<p align="center"> <img src="./R1.jpg" width="100%">    </p>
<p align="center"> Figure 4: Performance comparisons in terms of capacity-distortion trade-off. </p>

<p align="center"> <img src="./R2.jpg" width="100%">    </p>
<p align="center"> Figure 5: Performance comparisons of the proposed method using three mapping strategies.</p>

<p align="center"> <img src="./R3.jpg" width="100%">    </p>
<p align="center"> Figure 6: Comparison of PSNR for the capacity of 10,000 bits.</p>

<p align="center"> <img src="./R0.jpg" width="100%">    </p>
<p align="center"> Figure 7: Optimal 2D mapping using Pro-AMG for different capacities. </p>


## Environment
Matlab 2016b <br>


## Acknowledgement
This work was supported in part by the National Key Research and Development of China under Grant 2016YFB0800404, in part by the National Science Foundation of China under Grant 61502160,
Grant 61572052, Grant U1736213, and Grant 61332012, and in part by the Fundamental Research Funds for the Central Universities under Grant 2017RC008.


## Citation
If you find this work useful for your research, please cite
```
@ARTICLE{8419757,
  author={Ou, Bo and Li, Xiaolong and Zhang, Weiming and Zhao, Yao},
  journal={IEEE Transactions on Circuits and Systems for Video Technology}, 
  title={Improving Pairwise PEE via Hybrid-Dimensional Histogram Generation and Adaptive Mapping Selection}, 
  year={2019},
  volume={29},
  number={7},
  pages={2176-2190},
  doi={10.1109/TCSVT.2018.2859792}}
```

## License and Copyright
The project is open source under MIT license (see the ``` LICENSE ``` file).

