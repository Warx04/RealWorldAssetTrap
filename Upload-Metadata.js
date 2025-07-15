const axios = require("axios");
const fs = require("fs");
const FormData = require("form-data");

const PINATA_JWT = "Bearer YourPinataJWT" //Only Change YourPinataJWT, Keep it for Bearer
const metadata = {
  name: "", // your Realworldasset name
  description: "", your Realworldasset description
  image: "ipfs://bafy.......", // filled hash after upload foto on pinata
  attributes: [
    { trait_type: "Type", value: "TypeRWA" }, // Change TypeRWA
    { trait_type: "Location", value: "LocationRWA" }, Change LocationRWA
    { trait_type: "Legal Status", value: "Public/PrivateRWA" }, //Change Public or Private
    { trait_type: "Value", value: "$3,000,000" } // Price value change
  ]
};

async function uploadFile() {
  const formData = new FormData();
  formData.append("file", fs.createReadStream("./Koenigsegg-Jesko-Attack.jpg"));

  const res = await axios.post("https://api.pinata.cloud/pinning/pinFileToIPFS", formData, {
    headers: {
      Authorization: PINATA_JWT,
      ...formData.getHeaders()
    }
  });

  return `ipfs://${res.data.IpfsHash}`;
}

async function uploadMetadata(ipfsImage) {
  metadata.image = ipfsImage;
  const res = await axios.post("https://api.pinata.cloud/pinning/pinJSONToIPFS", metadata, {
    headers: { Authorization: PINATA_JWT }
  });

  return `ipfs://${res.data.IpfsHash}`;
}

async function main() {
  const imageURI = await uploadFile();
  console.log("Image uploaded to:", imageURI);

  const metadataURI = await uploadMetadata(imageURI);
  console.log("Metadata uploaded to:", metadataURI);
}

main().catch(console.error);
