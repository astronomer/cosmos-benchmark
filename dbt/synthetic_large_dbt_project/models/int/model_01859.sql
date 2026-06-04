{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00993') }},
        {{ ref('model_01048') }},
        {{ ref('model_00790') }}
)
select id, 'model_01859' as name from sources
