{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00158') }}
)
select id, 'model_01371' as name from sources
