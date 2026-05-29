{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00504') }},
        {{ ref('model_00477') }},
        {{ ref('model_00206') }}
)
select id, 'model_01402' as name from sources
