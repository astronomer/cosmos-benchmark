{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01110') }},
        {{ ref('model_01235') }},
        {{ ref('model_01347') }}
)
select id, 'model_02030' as name from sources
