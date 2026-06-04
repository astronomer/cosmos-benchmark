{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01495') }},
        {{ ref('model_01153') }}
)
select id, 'model_02204' as name from sources
