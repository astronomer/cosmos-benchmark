{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01917') }},
        {{ ref('model_02204') }}
)
select id, 'model_02676' as name from sources
