{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00984') }},
        {{ ref('model_01062') }},
        {{ ref('model_01400') }}
)
select id, 'model_01810' as name from sources
