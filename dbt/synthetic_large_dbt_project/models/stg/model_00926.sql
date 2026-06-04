{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00135') }},
        {{ ref('model_00727') }},
        {{ ref('model_00665') }}
)
select id, 'model_00926' as name from sources
