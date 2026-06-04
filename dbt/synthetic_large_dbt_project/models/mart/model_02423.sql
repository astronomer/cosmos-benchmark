{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01584') }},
        {{ ref('model_01597') }},
        {{ ref('model_02234') }}
)
select id, 'model_02423' as name from sources
