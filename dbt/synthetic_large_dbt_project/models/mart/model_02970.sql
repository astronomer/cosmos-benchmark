{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01622') }},
        {{ ref('model_02242') }},
        {{ ref('model_01925') }}
)
select id, 'model_02970' as name from sources
