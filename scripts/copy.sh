#!/bin/bash

server=graham
#seqs=(1YCQ.fasta 2AZE.fasta)
#seqs=(1YCQ.fasta 2AZE.fasta 2M3M.fasta 2QTV.fasta 2RSN.fasta 4U7T.fasta)
#seqs=(1AWR.fasta 1CZY.fasta 1EG4.fasta 1ELW.fasta 1ER8.fasta 1JD5.fasta)
#seqs=(1ozs 1tce 1i8h 1h8b 1h3h 1sb0 2laj 2xze 2m3m 2czy 2rsn 3ql9 4x34 4z0r)
#seqs=(1h3h 1h8b 1i8h 1ozs 1sb0 1tce 2czy 2laj 2m3m 2rsn)
#seqs=(3ixs 3fdt 3g2v 5urn 4gng 5heb 3mxc 3wgx 3g2u)
#seqs=(3g2u 3mxc 3g2v 3fdt 5urn)
#seqs=(1PNB 1SSE 1S5R 1Q5W 1QFN 1J2J 1D5S 1C8O 1JGN 1CF4 1OZS 1PD7 1L4W 1ORY 1JMT 1UEL 1WLP 1S5R 1QFN 1XR0 1XTG 1YHN 2AFF 2BBN 2DOH 2DT7 2FHO 2FOT 2GGV 2GP9 2JMX 2JSS 2JU0 2K42 2KC8 2KDU 2KHW 2KJ4 2KJE 2LEH 2OFQ 2PHG 2PQ4 2RNR 2ROZ 2ZQP 3BZV 3CAA 3H8K 3HK3 3M51 3MN7 4LX3 4MMT 5GTU 5L0T 6LPH 6WUD 6XFL 7OVC 7OY3)
seqs=(1C8O 1CF4 1D5S 1J2J 1JGN 1JMT 1L4W 1ORY 1OZS 1PD7 1PNB 1Q5W 1QFN 1S5R 1SSE 1UEL 1WLP 1XR0 1XTG 1YHN 2AFF 2AUH 2BBN 2DOH 2DT7 2FHO 2FOT 2GGV 2GP9 2JMX 2JSS 2JU0 2K42 2KC8 2KDU 2KHW 2KJ4 2KJE 2LEH 2OFQ 2PHG 2PQ4 2RNR 2ROZ 2ZQP 3BZV 3CAA 3H8K 3HK3 3HM6 3M1F 3M51 3MN7 4LX3 4MMT 5GTU 5L0T 6LPH 6SBA 6WUD 6XFL 7A48 7B2B 7BY2 7CQP 7DCP 7DHG 7E2H 7EV8 7FB5 7JQD 7JYZ 7LJ0 7LWB 7NDX 7NJ1 7OS1 7OVC 7OY3 7P9U 7PKU 7QV8 7S5J 7TGG 7VLJ 7VSI)

local_data_dir="../../data"
#local_data_dir="/media/fred/Local Disk/Projects/bioinfo/data"
cc_data_dir="fred862@${server}.computecanada.ca:~/scratch/fred862/data/bioinfo"

#############
#upload data
#############
upload_data=false

if $upload_data; then
    exps=(idr/polg_g_20)

    for exp in ${exps[@]} ; do
        for pdb_id in ${seqs[@]} ; do
            cc_dir="fred862@${server}.computecanada.ca:~/scratch/fred862/data/bioinfo/input/seq_to_pred/${exp}"
            local_dir="../../data/input/${exp}/${pdb_id}"
        done
    done

    scp $local_dir $cc_dir
fi

#################
# download input
#################
download_input=false

cc_input_dir="${cc_data_dir}/input/seq_to_pred"

if $download_input; then
    for exp in ${exps[@]}
    do
        cur_local_data_dir="${local_data_dir}/input/${exp}"

        for fn in pdb_cho0.npy
        do
            cc_fn="${cc_input_dir}/${exp}/${fn}"
            if [ ! -d $local_data_dir ]
            then
                mkdir -p $local_data_dir
            fi
            scp $cc_fn $cur_local_data_dir
        done
    done

    cd "$cur_dir"
fi

##################
# download output
##################
download_files=true

exps=(ds1_af_full/poly_g_20_fasta)
#exps=(dibs_af_full/poly_g_6 ds1_af_full/poly_g_24 dibs_af_full/poly_g_48 dibs_af_full/poly_g_96)

cc_output_dir="${cc_data_dir}/output"
local_output_dir="${local_data_dir}/output"

if [ ! -d $local_output_dir ]
then
    mkdir -p $local_output_dir
fi

for exp in ${exps[@]}
do
    for seq in ${seqs[@]}
    do
        echo $seq
        local_pdb_dir="${local_output_dir}/${exp}/${seq^^}.fasta"
        if [ ! -d $local_pdb_dir ] ; then
            mkdir -p $local_pdb_dir
        fi

        if $download_files ; then
            for nm in ranked_0.pdb ranking_debug.json
            do
                ccdir="${cc_output_dir}/${exp}/${seq^^}.fasta/${nm}"
                scp $ccdir $local_pdb_dir
            done
        fi
    done
done
