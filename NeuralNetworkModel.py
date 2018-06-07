import numpy as np

import matplotlib.pyplot as plt
from keras.utils import np_utils
import keras.models as models
from keras.models import Sequential
from keras.layers import Dense, Dropout
from sklearn.preprocessing import LabelEncoder
from keras import regularizers

#-----------------------------------------------------------------------------#
#Load training and eval data
dataset = np.genfromtxt("/Volumes/LPR_2018/LicensePlates/data_first_filter/Train.csv",
                        delimiter = ',').astype(np.float32)
X1 = dataset[:,:-1].copy()
y1 = dataset[:,-1].copy()
dataset2 = np.genfromtxt("/Volumes/LPR_2018/LicensePlates/data_first_filter/Validation.csv",
                        delimiter = ',').astype(np.float32)
X2 = dataset[:,:-1].copy()
y2 = dataset[:,-1].copy()
X_train = np.concatenate((X1, X2),axis=0)
y_train = np.concatenate((y1, y2),axis=0)
#X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2)
dataset = np.genfromtxt("/Volumes/LPR_2018/LicensePlates/binaryLPR_test.csv",
                        delimiter = ',').astype(np.float32)
X_test = dataset[:,:-1].copy()
y_test = dataset[:,-1].copy()



# encode class values as integers
encoder = LabelEncoder()
encoder.fit(y_train)
encoded_Y = encoder.transform(y_train)
# convert integers to dummy variables (i.e. one hot encoded)
y_train = np_utils.to_categorical(encoded_Y)

encoder = LabelEncoder()
encoder.fit(y_test)
encoded_Ytst = encoder.transform(y_test)
# convert integers to dummy variables (i.e. one hot encoded)
y_test = np_utils.to_categorical(encoded_Ytst)
#-----------------------------------------------------------------------------#
def plot_confusion_matrix(cm, classes,
                          cmap=plt.cm.afmhot):

    cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
    
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title('Confusion Matrix')
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation = 45)
    plt.yticks(tick_marks, classes)

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
#-----------------------------------------------------------------------------#

model = Sequential()
model.add(Dense(1200, input_dim=800, activation='relu',
                kernel_regularizer=regularizers.l2(0.3),
                activity_regularizer=regularizers.l2(0.3),
                bias_regularizer=regularizers.l2(0.3)))
model.add(Dense(800, input_dim=1200, activation='relu',
                kernel_regularizer=regularizers.l2(0.3),
                activity_regularizer=regularizers.l2(0.3),
                bias_regularizer=regularizers.l2(0.3)))
model.add(Dense(36, activation='softmax'))
#-----------------------------------------------------------------------------#
model.compile(loss='categorical_crossentropy',
              optimizer='adam',
              metrics=['accuracy'])
#-----------------------------------------------------------------------------#
model.fit(X_train, y_train,
          epochs=10,
          batch_size=300, verbose=2)
score = model.evaluate(X_test, y_test, batch_size=200, verbose =1)

#-----------------------------------------------------------------------------#

# Plot confusion matrix
class_names = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J','K',
               'L', 'M', 'N' ,'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
               'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6',
               '7', '8', '9']
test_Y_hat = model.predict(X_test, batch_size=200)
conf = np.zeros([len(class_names),len(class_names)])
confnorm = np.zeros([len(class_names),len(class_names)])
for i in range(0,X_test.shape[0]):
    j = list(y_test[i,:]).index(1)
    k = int(np.argmax(test_Y_hat[i,:]))
    conf[j,k] = conf[j,k] + 1
for i in range(0,len(class_names)):
    confnorm[i,:] = conf[i,:] / np.sum(conf[i,:])
plot_confusion_matrix(confnorm, classes=class_names)

model_json = model.to_json()
#with open("estimator.json", "w") as json_file:
#    json_file.write(estimator_json)
# serialize weights to HDF5
model.save("modelLPRMLP2-b.h5")
print("Saved model to disk")

