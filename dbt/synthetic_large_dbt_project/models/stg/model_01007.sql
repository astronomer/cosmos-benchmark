{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00495') }},
        {{ ref('model_00259') }},
        {{ ref('model_00314') }}
)
select id, 'model_01007' as name from sources
