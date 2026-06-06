{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00665') }},
        {{ ref('model_00382') }},
        {{ ref('model_00188') }}
)
select id, 'model_01150' as name from sources
