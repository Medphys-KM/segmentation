# Root dir
ROOT_DIR=/amax/deeplearning/Project/trainMR
CAFFE_BIN=/home/amax/caffe-fast-rcnn/build/tools/caffe.bin

NET_ID=01_resnet
NUM_LABELS=4
DATA_ROOT=''
DEV_ID=3
TRAIN_SET=train
# EXP固定为rectum, 与预测相�?EXP=MRI

if [ $# != 3 ]; then
	echo "参数错误!!"
	exit 1
fi

# �?个参数为病种�?DIAGNOSIS=$1
# �?个参数为器官�?ORGAN=$2
# �?个参数为初始化模型路�?INIT_MODEL_PATH=$3

TXT_DIR=${ROOT_DIR}/txt

## Create dirs
CONFIG_DIR=${ROOT_DIR}/config
LOG_DIR=${ROOT_DIR}/logs/${NET_ID}
mkdir -p ${LOG_DIR}
export GLOG_log_dir=${LOG_DIR}

## Run
MODEL=${INIT_MODEL_PATH}
if [ ! -f ${MODEL} ]; then
	echo "No Such Model!!"
	exit 1
fi
echo Training net ${EXP}/${NET_ID}
for pname in train solver; do
			sed "$(eval echo $(cat ${CONFIG_DIR}/sub.sed))" \
					${CONFIG_DIR}/${pname}.prototxt > ${CONFIG_DIR}/${pname}_${TRAIN_SET}.prototxt
done

CMD="${CAFFE_BIN} train \
 --solver=${CONFIG_DIR}/solver_${TRAIN_SET}.prototxt \
 --gpu=${DEV_ID}"
# CMD1="${CAFFE_BIN} time --model ${CONFIG_DIR}/train_train.prototxt --solver=${CONFIG_DIR}/solver_${TRAIN_SET}.prototxt --weights=${MODEL} --gpu=${DEV_ID}"
echo "TRAIN_SET :" ${TRAIN_SET}
if [ -f ${MODEL} ]; then
		CMD="${CMD} --weights=${MODEL}"
fi
echo Running ${CMD} && ${CMD}
