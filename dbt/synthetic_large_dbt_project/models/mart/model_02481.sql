{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01767') }},
        {{ ref('model_02223') }}
)
select id, 'model_02481' as name from sources
