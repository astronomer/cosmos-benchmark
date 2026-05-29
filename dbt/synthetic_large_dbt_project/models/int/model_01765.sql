{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01471') }},
        {{ ref('model_01135') }}
)
select id, 'model_01765' as name from sources
