{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01746') }},
        {{ ref('model_02043') }},
        {{ ref('model_01507') }}
)
select id, 'model_02595' as name from sources
